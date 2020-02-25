https://www.tutorialspoint.com/ipc-through-shared-memory

![Shared Memory IPC](https://raw.githubusercontent.com/dennyzhang/cheatsheet.dennyzhang.com/master/cheatsheet-concurrency-A4/code-example/shared-memory/shared_memory.jpg)

- shmget: Create/retrieve a shared memory segment
- shmat: Attach process to a shared memory segment
- shmdt: Detach the process from a shared memory segment
- shmctl: Control operations on the shared memory segment. e.g, destroy it.

```
g++ ./reader.cpp  -o ./reader

g++ ./writer.cpp  -o ./writer

./writer

./reader
```
