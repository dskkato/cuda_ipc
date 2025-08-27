cmake_minimum_required(VERSION 3.10)
project(cuda_ipc_sample LANGUAGES CXX CUDA)

add_executable(ipc_writer src/ipc_writer.cu)
add_executable(ipc_reader src/ipc_reader.cu)
set_target_properties(ipc_writer ipc_reader PROPERTIES CUDA_SEPARABLE_COMPILATION ON)

