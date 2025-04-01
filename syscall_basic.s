.section .text
.global _start
_start:
	mov w8, #467
	svc #0

	mov w8, #93
	mov x0, #0
	svc #0
