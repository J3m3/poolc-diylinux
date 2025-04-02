/*
 * There are indeed many "silly" points in this implementation...
 * Though, I think we can learn a lot of things while implementing
 * and discussing about this (again) "silly" system call.
 */

#include <linux/compat.h>
#include <linux/rcupdate.h>
#include <linux/sched.h>
#include <linux/stddef.h>
#include <linux/string.h>
#include <linux/syscalls.h>
#include <linux/types.h>
#include <linux/uaccess.h>

struct silly_info {
	int nice;
	__kernel_ulong_t start_heap;
	__kernel_ulong_t end_heap;
	char comm[TASK_COMM_LEN];
};

struct compat_silly_info {
	int nice;
	compat_ulong_t start_heap;
	compat_ulong_t end_heap;
	char comm[TASK_COMM_LEN];
};

long do_sys_silly(pid_t pid, struct silly_info *kinfo, bool is_compat);
long do_sys_silly(pid_t pid, struct silly_info *kinfo, bool is_compat)
{
	if (pid < 1)
		return -EINVAL;

	struct task_struct *task = find_get_task_by_vpid(pid);
	if (!task)
		return -ESRCH;
	// A "silly" guard that prevents 32-bit process from accessing 64-bit
	// processes and vice versa. This subtly tempts us to explore the
	// intricacies of compatibility system call implementation. It creates
	// an artificial need to bridge the gap between 32-bit and 64-bit worlds.
	// This also simplifies `syscall_test.c`, since both system call
	// implementation can share (textually) same struct.
	if (is_compat_thread(task_thread_info(task)) ^ is_compat) {
		put_task_struct(task);
		return -ESRCH;
	}

	// Retrieve nice value
	kinfo->nice = task_nice(task);

	// Retrieve command
	get_task_comm(kinfo->comm, task);

	// Retrieve memory info
	struct mm_struct *mm = get_task_mm(task);
	if (!mm) {
		put_task_struct(task);
		return -EFAULT;
	}
	spin_lock(&mm->arg_lock);
	kinfo->start_heap = mm->start_brk;
	kinfo->end_heap = mm->brk;
	spin_unlock(&mm->arg_lock);

	mmput(mm);
	put_task_struct(task);

	return 0;
}

SYSCALL_DEFINE2(silly, pid_t, pid, struct silly_info __user *, uinfo)
{
	printk(KERN_INFO "Hello from silly call!\n");

	struct silly_info kinfo;
	memset(&kinfo, 0, sizeof(kinfo));

	long err = do_sys_silly(pid, &kinfo, false);
	if (err)
		return err;

	// See also `copy_struct_to_user`
	if (copy_to_user(uinfo, &kinfo, sizeof(kinfo)))
		return -EFAULT;

	return 0;
}

COMPAT_SYSCALL_DEFINE2(silly, pid_t, pid, struct compat_silly_info __user *,
		       ucinfo)
{
	printk(KERN_INFO "Hello from compat silly call!\n");

	struct silly_info kinfo;
	memset(&kinfo, 0, sizeof(kinfo));

	long err = do_sys_silly(pid, &kinfo, true);
	if (err)
		return err;

	struct compat_silly_info kcinfo;
	memset(&kcinfo, 0, sizeof(kcinfo));
	kcinfo.nice = kinfo.nice;
	kcinfo.start_heap = (compat_ulong_t)kinfo.start_heap;
	kcinfo.end_heap = (compat_ulong_t)kinfo.end_heap;
	strscpy_pad(kcinfo.comm, kinfo.comm, TASK_COMM_LEN);

	// See also `copy_struct_to_user`
	if (copy_to_user(ucinfo, &kcinfo, sizeof(kcinfo)))
		return -EFAULT;

	return 0;
}
