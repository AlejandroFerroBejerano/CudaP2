#OCELOT_LIB= -L<ruta a la instalacion de ocelot>/lib -locelot

all: ejer1 ejer2 ejer3

ejer1: ejer1.cu
	nvcc -arch=sm_20 $ -o $@ $^

ejer2: ejer2.cu
	nvcc -arch=sm_20 $ -o $@ $^

ejer3: ejer3.cu
	nvcc -arch=sm_20 $ -o $@ $^

clean:
	$(RM) *~ *.o ejer?
