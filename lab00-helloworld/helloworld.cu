#include <cuda.h>
#include <stdio.h>

__global__
void helloword()
{
	printf("Hello World\n")
}

int main(int argc, char** argv)
{
	//Launch 1 block , each block has 1 thread 
	printf("Launch 1 block , each block has 1 thread \n");
	helloword<<<  1, 1 >>>();
	printf("\n");
	
	//Launch 1 block , each block has 3 threads
	// printf("Launch 1 block , each block has 3 threads\n");
	// helloword<<<  /*TODO*/, 3 >>>();
	
	//Launch 2 blocks, each block has 1 thread
	// printf("Launch 2 blocks, each block has 1 thread \n");
	// helloword<<<  /*TODO*/, 3 >>>();
		
	//Launch 2 blocks, each block has 3 threads
	// printf("Launch 2 blocks, each block has 3 threads\n");
	// helloword<<<  /*TODO*/, /*TODO*/ >>>();
	
	return 0;
}