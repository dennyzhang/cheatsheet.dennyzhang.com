#include <pthread.h>
#include <stdio.h>

void *func(void *arg) {
  printf("child thread says %s\n", (char *) arg);
  pthread_exit((void *)99);
}

int main() {
  pthread_t handle;
  int exitcode;
  pthread_create(&handle, NULL, func, "hi");
  pthread_join(handle, (void **)&exitcode);
  printf("exit code: %d\n", exitcode);  
}
