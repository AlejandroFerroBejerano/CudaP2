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
	int blockx, blocky, position_x,position_y, position,position_reverse;
	int gridx = Columnas/blockDim.x + Columnas%blockDim.x;
  int gridy = Filas/blockDim.y + Filas%blockDim.y;
			
  for(blockx=0; blockx <= gridx; blockx++){
		for(blocky=0; blocky <= gridy; blocky++){

			position_x = blockx * blockDim.x + threadIdx.x;
  		position_y = blocky * blockDim.y + threadIdx.y;
			position = position_y * Columnas + position_x;
			position_reverse = position_x * Filas + position_y;

			if (position_x >= Columnas || position_y >= Filas){
    		/*pass*/
  		}else{
    		dev_b[position_reverse] = dev_a[position];
  		}
		}
  }/*finfor*/
}

void print_matriz(int resultado[Filas][Columnas]){
  int i,j;
  for (i=0; i< Filas; i++) {
		for(j=0; j< Columnas; j++){
	 	 printf("%d\t", resultado[i][j]);	
		}
     printf("\n");
  }
  printf("\n");
}

int
main(int argc, char** argv)
{
  int a[Filas][Columnas], b[Columnas][Filas];
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
