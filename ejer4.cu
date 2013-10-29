#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

#define Filas 5
#define Columnas 7

__global__ void 
copiar(int *dev_a, int *dev_b)
{
  int position_x = threadIdx.x;
  int position_y = threadIdx.y + blockDim.x * blockDim.y * threadIdx.y;
  int position = position_x + position_y;
  int desp = 0;
  int iter = (Columnas/blockDim.x + Columnas%blockDim.x) * (Filas/blockDim.y + Filas%blockDim.y);

  for(int i=0; i <= iter; i++){
    desp= i * blockDim.x;
    dev_b[position + desp] = dev_a[(Filas * Columnas -1) - (position + desp)];
  }
}

int
main(int argc, char** argv)
{
  int a[Filas][Columnas], b[Filas][Columnas];
  int *dev_a, *dev_b;
  int i,j,pos=0;
  dim3 nbloques(1,1);
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
  
  copiar<<<nbloques, nhebras>>>(dev_a, dev_b);

  cudaMemcpy(b, dev_b, Filas * Columnas * sizeof(int), cudaMemcpyDeviceToHost);
  pos = 0;
  for(i = 0; i < Filas; i++){
    for (j = 0; j< Columnas; j++){
    	printf("%d# %d -> %d \n",pos++, a[i][j], b[i][j]);
    }
  }

  cudaFree(dev_a);
  cudaFree(dev_b);

  return 0;
} 