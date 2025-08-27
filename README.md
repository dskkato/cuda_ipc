# CUDA IPC Sample

This repository contains a minimal example demonstrating CUDA's inter-process communication (IPC) feature. It allocates device memory in one process, shares it with another process using a CUDA IPC handle, and shows that both processes can access the same memory.

## Requirements

- Ubuntu with a CUDA-capable GPU
- CUDA toolkit (provides `nvcc` and runtime libraries)
- CMake 3.10 or newer

## Build

```bash
cmake -S . -B build
cmake --build build
```

## Run

In one terminal, start the writer to allocate memory and export the handle:

```bash
./build/ipc_writer handle.bin
```

In another terminal, run the reader to open the handle and read the data:

```bash
./build/ipc_reader handle.bin
```

The reader should print output similar to:

```
Receiver read: 10 11 12 13
```

Return to the writer terminal and press Enter to free the device memory.

## Notes

This sample is for educational purposes and omits robust error handling. Make sure to run the program on a system with a CUDA-capable GPU and proper driver installation.

