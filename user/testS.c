#include "kernel/types.h"
#include "user/user.h"

void waste_time() {
  volatile unsigned long long i;
  for (i = 0; i < 3000000ULL; ++i);
}

int main() {


  for (int i = 0; i < 3; i++) { 
    int pid = forkprio(i);
    if (pid == 0) {//filho
      for (int j = 0; j < 3; j++) {
        printf("\nstop pid=%d (id=%d)\n\n", getpid(), i);
        waste_time();
        sleep(1);
      }
      exit(0);
    }
  }

  for (int i = 0; i < 3; i++) {
    wait(0);
  }

  exit(0);
}
