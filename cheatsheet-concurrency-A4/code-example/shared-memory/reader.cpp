#include <iostream>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <stdio.h>
using namespace std;
main() {
   key_t my_key = ftok("shmfile",65); // ftok function is used to generate unique key
   int shmid = shmget(my_key,1024,0666|IPC_CREAT); // shmget returns an ide in shmid
   char *str = (char*) shmat(shmid,(void*)0,0); // shmat to join to shared memory
   printf("Data read from memory: %s\n",str);
   shmdt(str);
   shmctl(shmid,IPC_RMID,NULL); // destroy the shared memory
}
