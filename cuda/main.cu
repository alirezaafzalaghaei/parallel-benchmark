#include<iostream>
#include<stdlib.h>
#include<time.h>


#define N 999999
#define nblocks 100
using namespace std;

__global__ void cudaArrayMax(float *a, float *b)
{
    int id = threadIdx.x + blockDim.x *blockIdx.x;
    int stride = nblocks;
    __shared__ float cache[nblocks];

    float thmax = a[id];
    for (int i = id; i < N; i += stride)
        if (a[i] > thmax)
            thmax = a[i];

    cache[threadIdx.x] = thmax;
    __syncthreads();

    float max = cache[0];
    for (int i = 0; i < nblocks; i++)
        if (cache[i] > max)
            max = cache[i];

    b[blockIdx.x] = max;

}

int main()
{
    srand(time(0));
    float *ha, *ht, hmax;
    float *da, *dt, dmax;
    unsigned int size = N *sizeof(float);

    ha = (float *) malloc(size);
    ht = (float *) malloc(nblocks *sizeof(float));

    for (int i = 0; i < N; i++)
        ha[i] = rand() / (float) RAND_MAX;

    /* ----- BEGIN CPU ----- */
    
    clock_t cpustart = clock();
    
    hmax = ha[0];
    for (int i = 0; i < N; i++)
        if (ha[i] > hmax)
            hmax = ha[i];
    
    clock_t cpuend = clock();    
    float cputime = 1000 *(cpuend - cpustart) / (float) CLOCKS_PER_SEC;

    cout << "cpu max is " << hmax << " in " << cputime << endl;

    /* ----- END CPU ----- */    

    /* ----- BEGIN GPU ----- */
    
    cudaMalloc((void **) &da, size);
    cudaMalloc((void **) &dt, nblocks *sizeof(float));

    clock_t gpustart = clock();
    
    cudaMemcpy(da, ha, size, cudaMemcpyHostToDevice);

    cudaArrayMax <<<nblocks, nblocks>>> (da, dt);

    cudaMemcpy(ht, dt, nblocks *sizeof(float), cudaMemcpyDeviceToHost);

    dmax = ht[0];
    for (int i = 0; i < nblocks; i++)
        if (ht[i] > dmax)
            dmax = ht[i];
    
    clock_t gpuend = clock();
    float gputime = 1000 *(gpuend - gpustart) / (float) CLOCKS_PER_SEC;

    cout << "gpu max is " << dmax << " in " << gputime << endl;

    /* ----- END GPU ----- */

    cout << "speedup = " << cputime / gputime;

    cudaFree(da);
    cudaFree(dt);

    return 0;

} 
