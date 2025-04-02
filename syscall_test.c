#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

typedef struct silly_info {
  int nice;
  void *start_heap;
  void *end_heap;
  char comm[16];
} SillyInfo;

int main(int argc, char **argv) {
  SillyInfo info = {0};
  long r = syscall(467, argc < 2 ? getpid() : atoi(argv[1]), &info);
  if (r < 0) {
    fprintf(stderr, "Errno: %ld\n", r);
    perror("Error");
  }

  printf("nice: %d\n", info.nice);
  printf("start_heap: %p\n", info.start_heap);
  printf("end_heap: %p\n", info.end_heap);
  printf("command: %s\n", info.comm);

  return 0;
}
