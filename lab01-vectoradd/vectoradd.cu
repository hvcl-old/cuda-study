#include<stdio.h>
#include<stdlib.h>
#include<time.h>
#include<assert.h>
#include<unistd.h>

#define NUMELEMENT 1E6

void vecADD(float* h_A, float* h_B, float* h_C, int n)
{
	for (int i = 0 ; i < n ; i++)
		h_C[i] = h_A[i] + h_B[i];
}

__global__ void vecADDKernel(float* d_A, float* d_B, float* d_C, int n)
{
	int i = threadIdx.x + blockDim.x * blockIdx.x;
	
	if (i < n)
		d_C[i] = d_A[i] + d_B[i];
}

double get_mesc (struct timespec t1, struct timespec t2){
	return ((t2.tv_sec-t1.tv_sec)*1E9 + (t2.tv_nsec - t1.tv_nsec))/1E3;
}

struct timespec t_start, t_end;

int main()
{
	float *h_A, *h_B, *h_C;
	
	h_A = (float *)malloc(NUMELEMENT*sizeof(float));
	h_B = (float *)malloc(NUMELEMENT*sizeof(float));
	h_C = (float *)malloc(NUMELEMENT*sizeof(float));

	srand(222);

	for (int i = 0 ; i < NUMELEMENT ; i++)
	{
		h_A[i] = (float)(rand()%1000)/1000;
		h_B[i] = (float)(rand()%1000)/1000;
		h_C[i] = 0.0;
	}

	float *d_A, *d_B, *d_C;
	cudaMalloc((void**)&d_A,NUMELEMENT*sizeof(float));
	cudaMalloc((void**)&d_B,NUMELEMENT*sizeof(float));
	cudaMalloc((void**)&d_C,NUMELEMENT*sizeof(float));

	cudaMemcpy(d_A,h_A,NUMELEMENT*sizeof(float),cudaMemcpyHostToDevice);
	cudaMemcpy(d_B,h_B,NUMELEMENT*sizeof(float),cudaMemcpyHostToDevice);
	cudaMemcpy(d_C,h_C,NUMELEMENT*sizeof(float),cudaMemcpyHostToDevice);


	clock_gettime(CLOCK_REALTIME,&t_start);	
	vecADD(h_A,h_B,h_C,NUMELEMENT);
	clock_gettime(CLOCK_REALTIME,&t_end);	
	printf("CPU Time :: %.0f msec\n",get_mesc(t_start,t_end));


	clock_gettime(CLOCK_REALTIME,&t_start);	
	vecADDKernel<<<ceil(NUMELEMENT/64),64>>>(d_A,d_B,d_C,NUMELEMENT);
	cudaThreadSynchronize();
	clock_gettime(CLOCK_REALTIME,&t_end);	
	printf("GPU Time :: %.0f msec\n",get_mesc(t_start,t_end));


	float* h_R = (float *)malloc(NUMELEMENT*sizeof(float));
	cudaMemcpy(h_R,d_C,NUMELEMENT*sizeof(float),cudaMemcpyDeviceToHost);

	for (int i = 0 ; i < NUMELEMENT ; i++)
		assert(h_R[i] == h_C[i]);

	free(h_A);
	free(h_B);
	free(h_C);
	free(h_R);

	cudaFree(d_A);
	cudaFree(d_B);
	cudaFree(d_C);

	return 0;
}
