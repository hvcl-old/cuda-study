import pycuda.driver as cuda
from pycuda.compiler import SourceModule

cuda.init() # init
dev = cuda.Device(0) # 0 is device number
ctx = dev.make_context() # make context in the device

function_code = """
#include <stdio.h>
__global__ void helloworld(){
	printf("Hello World");
}
"""

mod = SourceModule(function_code)
func = mod.get_function("helloworld")
args = []
func(*args, block=(1,1,1), grid=(1,1))
print ""

# Launch 1 block , each block has 3 threads
# print "Launch 1 block , each block has 3 threads"
#args = []
#func(*args, block="todo", grid=(1,1))
#print ""

# Launch 2 blocks, each block has 1 thread
# print "Launch 2 blocks, each block has 1 thread"
#args = []
#func(*args, block=(1,1,2), grid=(1,1))
# print ""

# Launch 2 blocks, each block has 3 threads
# print "Launch 2 blocks, each block has 3 threads"
#args = []
#func(*args, block="todo", grid="todo")
# print ""

ctx.synchronize()
ctx.pop()
