#include <cstdio>
#include <cuda_runtime.h>

__global__ void fill(int *data, int value) {
    int idx = threadIdx.x;
    data[idx] = value + idx;
}

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <handle_file>\n", argv[0]);
        return 1;
    }
    const char *handleFile = argv[1];
    const int N = 4;
    int *devPtr;
    if (cudaMalloc(&devPtr, N * sizeof(int)) != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed\n");
        return 1;
    }

    fill<<<1, N>>>(devPtr, 10);
    if (cudaDeviceSynchronize() != cudaSuccess) {
        fprintf(stderr, "kernel execution failed\n");
        cudaFree(devPtr);
        return 1;
    }

    cudaIpcMemHandle_t handle;
    if (cudaIpcGetMemHandle(&handle, devPtr) != cudaSuccess) {
        fprintf(stderr, "cudaIpcGetMemHandle failed\n");
        cudaFree(devPtr);
        return 1;
    }

    FILE *f = fopen(handleFile, "wb");
    if (!f) {
        perror("fopen");
        cudaFree(devPtr);
        return 1;
    }
    fwrite(&handle, sizeof(handle), 1, f);
    fclose(f);

    printf("Handle written to %s. Run receiver and press Enter when done.\n", handleFile);
    getchar();

    cudaFree(devPtr);
    return 0;
}

