CudaP2
======

Practica 2 en cuda Arquitectura de Computadores

	Dada una matriz de enteros de 5 filas y 7 columnas, y
	utilizando como base un bloque de 2x3 elementos.

	--Ejer1 -- 
	Desarrollar un kernel que realice una copia de la matriz A a otra
	B idéntica, desplegando tantos bloques como sea necesario.

	--Ejer2--
	Modificar el kernel anterior para transponer filas y columnas de
	la matriz A sobre la matriz B.

	--Ejer3--	
	Desarrollar un kernel que realice la operación de copia con un
	único bloque.

	--Ejer4--	
	Modificar el kernel anterior para que en lugar de una copia se
	realice la transposición.

blockIdx.x -> // Posición del bloque respecto al eje x
blockIdx.y -> // Posicion del bloque respecto al eje y

threadIdx.x -> // Posición del thread dentro del bloque, respecto al eje x
threadIdx.y -> // Posición del thread dentro del bloque, respecto al eje y

blockDim.x -> // Dimensión del bloque en el eje x
blockDim.y -> // Dimensión del bloque en el eje y
