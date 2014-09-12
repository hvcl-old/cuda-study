#include <cuda.h>
#include <stdio.h>

///A device kernel function, just print out "Hello World"
__global__
void helloworld()
{
	printf("Hello World\n");
}

int main(int argc, char** argv)
{
	/// Use the first GPU on the machine
	cudaSetDevice(0);
	
	///Launch 1 block , each block has 1 thread 
	printf("Launch 1 block , each block has 1 thread \n");
	helloworld<<<  1, 1 >>>();
	printf("\n");
	
	///Launch 1 block , each block has 3 threads
	// printf("Launch 1 block , each block has 3 threads\n");
	// helloworld<<<  1, /*TODO*/ >>>();
	// printf("\n");
	
	///Launch 2 blocks, each block has 1 thread
	// printf("Launch 2 blocks, each block has 1 thread \n");
	// helloworld<<<  /*TODO*/, 1 >>>();
	// printf("\n");
	
	///Launch 2 blocks, each block has 3 threads
	// printf("Launch 2 blocks, each block has 3 threads\n");
	// helloworld<<<  /*TODO*/, /*TODO*/ >>>();
	// printf("\n");
	
	/// Why this? You can try to comment this one and see
	cudaDeviceSynchronize(); 
	return 0;
}