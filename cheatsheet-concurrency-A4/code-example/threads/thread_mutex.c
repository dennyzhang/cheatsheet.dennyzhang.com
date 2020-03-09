#include <pthread.h>
#include <stdio.h>

static int global = 0;
pthread_mutex_t mylock = PTHREAD_MUTEX_INITIALIZER;

void *func(void *arg) {
  int local, i;
  for (i=0; i<100000; i++) {
    pthread_mutex_lock(&mylock);
    local = global;
    local++;
    global = local;
    pthread_mutex_unlock(&mylock);
  }
  return NULL;
}

int main() {
  pthread_t t1, t2;
  pthread_create(&t1, NULL, func, NULL);
  pthread_create(&t2, NULL, func, NULL);
  pthread_join(t1, NULL);
  pthread_join(t2, NULL);
  printf("global = %d\n", global);
}
