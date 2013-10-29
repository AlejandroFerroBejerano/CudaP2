#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

#define Filas 5
#define Columnas 7

__global__ void 
trasponer(int *dev_a, int *dev_b)
{
  int position_x = blockIdx.x * blockDim.x + threadIdx.x;
  int position_y = blockDim.y * blockIdx.y + threadIdx.y;
  int position = position_y * Columnas + position_x;

  if (position_x >= Columnas || position_y >= Filas){
    /*pass*/
  }else{
    dev_b[position] = dev_a[(Filas * Columnas -1)-position];
  }
}

int
main(int argc, char** argv)
{
  int a[Filas][Columnas], b[Filas][Columnas];
  int *dev_a, *dev_b;
  int i,j,pos=0;
  dim3 nbloques(3,3);
  dim3 nhebras(3,2);

  cudaMalloc((void**) &dev_a, Filas * Columnas * sizeof(int));
  cudaMalloc((void**) &dev_b, Filas * Columnas * sizeof(int));
  
  // fill the arrays 'a' and 'b' on the CPU
  for (i=0; i<Filas; i++) {
	for(j=0; j<Columnas; j++){
		a[i][j]= pos++;
	}
  }

  cudaMemcpy(dev_a, a, Filas * Columnas * sizeof(int), cudaMemcpyHostToDevice);
  
  trasponer<<<nbloques, nhebras>>>(dev_a, dev_b);

  cudaMemcpy(b, dev_b, Filas * Columnas * sizeof(int), cudaMemcpyDeviceToHost);
  pos=0;
  for(i = 0; i < Filas; i++){
    for (j = 0; j< Columnas; j++){
    	printf("%d# %d -> %d \n",pos++, a[i][j], b[i][j]);
    }
  }

  cudaFree(dev_a);
  cudaFree(dev_b);

  return 0;
} 
