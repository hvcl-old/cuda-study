import pycuda.driver as cuda
from pycuda.compiler import SourceModule

cuda.init() # init
dev = cuda.Device(0) # 0 is device number
ctx = dev.make_context() # make context in the device

function_code = """
__global__ void vecADDKernel(float* d_A, float* d_B, float* d_C, int n)
{
	int i = threadIdx.x + blockDim.x * blockIdx.x;
	
	if (i < n)
		d_C[i] = d_A[i] + d_B[i];
}

"""
import numpy
import time

st = time.time()
n = 1000000
h_A = numpy.random.rand((n)).astype(numpy.float32)
h_B = numpy.random.rand((n)).astype(numpy.float32)
print "rand time:", numpy.int32( (time.time() - st)*1000)
st = time.time()
h_C = h_A + h_B
h_R = numpy.empty_like(h_A)
print "host addition time:", numpy.int32( (time.time() - st)*1000)

d_A = cuda.mem_alloc(h_A.nbytes)
d_B = cuda.mem_alloc(h_B.nbytes)
d_C = cuda.mem_alloc(h_A.nbytes)

cuda.memcpy_htod(d_A, h_A)
cuda.memcpy_htod(d_B, h_B)

mod = SourceModule(function_code)
func = mod.get_function("vecADDKernel")
args = [d_A,d_B,d_C,numpy.int32(n)]

st = time.time()
func(*args, block=(64,1,1), grid=(numpy.int32(n/64)+1,1))
ctx.synchronize()
print "GPU time:", numpy.int32( (time.time() - st)*1000)

st = time.time()
cuda.memcpy_dtoh(h_R, d_C)
print "copy time:", numpy.int32( (time.time() - st)*1000)

if h_C.all() == h_R.all():
	print "Ok"
else:
	print "No"

ctx.synchronize()
ctx.pop()
