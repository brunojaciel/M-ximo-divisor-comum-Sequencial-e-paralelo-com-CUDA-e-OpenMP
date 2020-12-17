#include <time.h>
#include <stdio.h>
#include <cuda.h>
#include <cuda_runtime.h>

__global__
void mdcSequencialCUDA(int *x, int *y, int *resto)
{
    do
    {
        *resto = *x % *y;
    
        *x = *y;
        *y = *resto;
    }
    while (*resto != 0);
}

int main(void)
{
  // Iniciando a contagem da execução do algoritmo
  clock_t t; //variável para armazenar tempo
  t = clock(); //armazena tempo

  // hospedando cópias de x,y e resto
  int x, y, resto;
  // Cópias do sistema de x,y e resto
  int *d_x, *d_y, *d_resto;
  int size = sizeof(int);

  // Alocando espaco para as variáveis
  cudaMalloc((void **) &d_x, size);
  cudaMalloc((void **) &d_y, size);
  cudaMalloc((void **) &d_resto, size);

  // Definido os valores de entrada
  x = 50;
  y = 20;
  resto = 1;

  // Copiando os valores de entrada para a GPU
  cudaMemcpy(d_x, &x, size, cudaMemcpyHostToDevice);
  cudaMemcpy(d_y, &y, size, cudaMemcpyHostToDevice);
  cudaMemcpy(d_resto, &resto, size, cudaMemcpyHostToDevice);

  // Resolvendo a operacao MDC dentro da GPU
  mdcSequencialCUDA<<<1,1>>>(d_x, d_y, d_resto);

  // Copiando o resultado de volta para o host
  cudaMemcpy(&x, d_x, size, cudaMemcpyDeviceToHost);
  //cudaMemcpy(&y, d_y, size, cudaMemcpyDeviceToHost);
  //cudaMemcpy(&resto, d_resto, size, cudaMemcpyDeviceToHost);
  
  

  // Limpando a memória
  cudaFree(d_x);
  cudaFree(d_y);
  cudaFree(d_resto);
  //free(x);
  //free(y);
  //free(resto);

  printf("Resultado: %i", x);

  // Finalizando a contagem da execução do algoritmo
  t = clock() - t; //tempo final - tempo inicial
  double tempo_execucao = (double)(((double)t)/(CLOCKS_PER_SEC/1000)); //Dando o resultado em milissegundos.
  //cout << "O tempo de execucao foi da aplicacao: " << (double)tempo_execucao << " milissegudos.";
  //printf("tempo de execucao: %f", tempo_execucao);
  printf(" Tempo gasto: %g ms.", tempo_execucao);

  

  return 0;

}
