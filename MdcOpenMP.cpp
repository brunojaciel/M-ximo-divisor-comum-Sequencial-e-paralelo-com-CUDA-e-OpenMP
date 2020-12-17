#include <iostream>
#include <time.h>
#include <stdio.h>
#include <omp.h>

using namespace std;

void mdcSequencial(int x, int y)
{
    int resto;

    do
    {
        resto = x % y;

        x = y;
        y = resto;
    }
    while (resto != 0);

    cout << "Resultado = " << x << "." << endl;
}

void mdcParaleloOpenMP(int x, int y)
{
    int resultado = 1;
    #pragma omp parallel num_threads(4)
    {
        int id = omp_get_thread_num() + 1;
        //printf("%i", id);
        int i = 1+id;
        for(i; i<id+1*id+1; i++){
        
        if(x % i == 0 && y % i == 0 && i > 1){
            x/=i;
            y/=i;
            resultado*=i;
            i--;
        } else if(x % i == 0 && y % i != 0)
            x/=i;
        else if(x % i != 0 && y % i == 0)
            y/=i;
        if(x == 1 && y == 1)
            i=id*id+1;
        }
    }
    
    cout << "Resultado = " << resultado << "." << endl;
}

int main()
{
    // Iniciando a contagem da execução do algoritmo
    clock_t t; //variável para armazenar tempo
    t = clock(); //armazena tempo

    int x = 50, y = 20;
    //Escolher o método no qual vai realizar o calculo
    mdcSequencial(x, y);
    mdcParaleloOpenMP(x, y);

    // Finalizando a contagem da execução do algoritmo
    t = clock() - t; //tempo final - tempo inicial
    double tempo_execucao = (double)(((double)t)/(CLOCKS_PER_SEC/1000)); //Dando o resultado em milissegundos.
    printf("Tempo gasto: %g ms.", tempo_execucao);

    return 0;
}
