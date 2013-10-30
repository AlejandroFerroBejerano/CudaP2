#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

#define Filas 5
#define Columnas 7
#define NbloquesX 3
#define NbloquesY 3
#define NhebrasX 3
#define NhebrasY 2

__global__ void 
trasponer(int *dev_a, int *dev_b)
{
  int position_x = blockIdx.x * blockDim.x + threadIdx.x;
  int position_y = blockDim.y * blockIdx.y + threadIdx.y;
  int position = position_y * Columnas + position_x;
  int position_reverse = position_x * Filas + position_y;

  if (position_x >= Columnas || position_y >= Filas){
    return;
  }else{
    dev_b[position_reverse] = dev_a[position];
  }
}


int
main(int argc, char** argv)
{
  int a[Filas][Columnas], b[Columnas][Filas];
  int *dev_a, *dev_b;
  int i,j,pos=0;
  dim3 nbloques(NbloquesX,NbloquesY);
  dim3 nhebras(NhebrasX,NhebrasY);

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

  printf("\nMatriz Origen\n");
  for (i=0; i< Filas; i++) {
	for(j=0; j< Columnas; j++){
	  printf("%d\t", a[i][j]);	
	}
    printf("\n");
  }
  printf("\nMatriz Traspuesta\n");
  for (i=0; i< Columnas; i++) {
	for(j=0; j< Filas; j++){
	  printf("%d\t", b[i][j]);	
	}
    printf("\n");
  }

  cudaFree(dev_a);
  cudaFree(dev_b);

  return 0;
} 
