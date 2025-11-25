#include "kernel/types.h"
#include "user/user.h"

#define N_CLASSES 4
#define N_SUBS 4 //sub processos por processo

int child[N_CLASSES * N_SUBS]; //adicionei subprocessos para poder visualizar o round robin
 
void waste_time(int prioridade){
  volatile unsigned long long i;
  sleep(5); //pq estava misturando os prints 
  printf("start pid=%d (classe=%d)\n", getpid(), prioridade);
  for (i = 0; i < 300000000ULL; ++i);
  printf("stop pid=%d (classe=%d)\n", getpid(), prioridade);
}

int
main(int argc, char *argv[])
{
  int n, m, pid;
  int prioridades[N_CLASSES] = {0, 1, 2, 3};  // uma de cada classe

  for (n=0; n<N_CLASSES; n++) {
    int classe = prioridades[n];  // salva a classe atual em uma variável local
    for (m=0; m<N_SUBS; m++) {
      pid = forkprio(classe);
      if (pid == 0) {
        waste_time(classe);
        exit(0);
      } else child[n * N_SUBS + m] = pid;
    }
  }


  for(n=0; n<N_CLASSES*N_SUBS; n++){
    pid = wait(0); 
    printf("child pid = %d finished!\n\n", pid);
  }

  exit(0);
}
