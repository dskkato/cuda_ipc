#include <cstdio>
#include <cuda_runtime.h>

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <handle_file>\n", argv[0]);
        return 1;
    }
    const char *handleFile = argv[1];

    FILE *f = fopen(handleFile, "rb");
    if (!f) {
        perror("fopen");
        return 1;
    }
    cudaIpcMemHandle_t handle;
    if (fread(&handle, sizeof(handle), 1, f) != 1) {
        fprintf(stderr, "fread failed\n");
        fclose(f);
        return 1;
    }
    fclose(f);

    int *devPtr;
    if (cudaIpcOpenMemHandle((void**)&devPtr, handle, cudaIpcMemLazyEnablePeerAccess) != cudaSuccess) {
        fprintf(stderr, "cudaIpcOpenMemHandle failed\n");
        return 1;
    }

    const int N = 4;
    int host[N];
    if (cudaMemcpy(host, devPtr, N * sizeof(int), cudaMemcpyDeviceToHost) != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed\n");
        cudaIpcCloseMemHandle(devPtr);
        return 1;
    }

    printf("Receiver read: ");
    for (int i = 0; i < N; ++i) {
        printf("%d ", host[i]);
    }
    printf("\n");

    cudaIpcCloseMemHandle(devPtr);
    return 0;
}

