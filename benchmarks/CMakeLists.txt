# =============================================================================
# Copyright (c) 2018-2020, NVIDIA CORPORATION.
# Modifications Copyright (C) 2023 Advanced Micro Devices, Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
# in compliance with the License. You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License
# is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
# or implied. See the License for the specific language governing permissions and limitations under
# the License.
# =============================================================================

# Modifications Copyright (c) 2024 Advanced Micro Devices, Inc.
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# Build options
option(DISABLE_DEPRECATION_WARNING "Disable warnings generated from deprecated declarations." OFF)
option(PER_THREAD_DEFAULT_STREAM "Build with per-thread default stream" OFF)

if(PER_THREAD_DEFAULT_STREAM)
  message(STATUS "RMM: Building benchmarks with per-thread default stream")
endif()

# compiler function

# This function takes in a benchmark name and benchmark source and handles setting all of the
# associated properties and linking to build the benchmark
function(ConfigureBench BENCH_NAME)
  set_source_files_properties(${ARGN}
                              "${CMAKE_CURRENT_SOURCE_DIR}/synchronization/synchronization.cpp" PROPERTIES LANGUAGE HIP)
  add_executable(${BENCH_NAME} ${ARGN}
                               "${CMAKE_CURRENT_SOURCE_DIR}/synchronization/synchronization.cpp")
  target_include_directories(${BENCH_NAME} PRIVATE "$<BUILD_INTERFACE:${RMM_SOURCE_DIR}>")
  set_target_properties(
    ${BENCH_NAME}
    PROPERTIES POSITION_INDEPENDENT_CODE ON
               RUNTIME_OUTPUT_DIRECTORY "$<BUILD_INTERFACE:${RMM_BINARY_DIR}/gbenchmarks>"
               HIP_ARCHITECTURES "${CMAKE_HIP_ARCHITECTURES}"
               INSTALL_RPATH "\$ORIGIN/../../../lib")
  target_link_libraries(${BENCH_NAME} benchmark::benchmark pthread rmm)
  target_compile_definitions(${BENCH_NAME}
                             PUBLIC "SPDLOG_ACTIVE_LEVEL=SPDLOG_LEVEL_${RMM_LOGGING_LEVEL}")

  if(PER_THREAD_DEFAULT_STREAM)
    target_compile_definitions(${BENCH_NAME} PUBLIC CUDA_API_PER_THREAD_DEFAULT_STREAM CUDA_API_PER_THREAD_DEFAULT_STREAM HIP_API_PER_THREAD_DEFAULT_STREAM __HIP_API_PER_THREAD_DEFAULT_STREAM__)
  endif()

  target_compile_options(
    ${BENCH_NAME} PUBLIC $<$<COMPILE_LANG_AND_ID:CXX,GNU,Clang>:-Wall -Werror
                         -Wno-error=deprecated-declarations -Wno-unknown-pragmas>)
  if(DISABLE_DEPRECATION_WARNING)
    target_compile_options(${BENCH_NAME}
                           PUBLIC $<$<COMPILE_LANGUAGE:HIP,CXX>:-Wno-deprecated-declarations>)
  endif()

  install(
    TARGETS ${BENCH_NAME}
    COMPONENT testing
    DESTINATION bin/benchmarks/librmm
    EXCLUDE_FROM_ALL)
endfunction(ConfigureBench)

# random allocations benchmark
ConfigureBench(RANDOM_ALLOCATIONS_BENCH random_allocations/random_allocations.cpp)

# replay benchmark
ConfigureBench(REPLAY_BENCH replay/replay.cpp)

# uvector benchmark
ConfigureBench(UVECTOR_BENCH device_uvector/device_uvector_bench.cu)

# cuda_stream_pool benchmark
ConfigureBench(CUDA_STREAM_POOL_BENCH cuda_stream_pool/cuda_stream_pool_bench.cpp)

# multi stream allocations
ConfigureBench(MULTI_STREAM_ALLOCATIONS_BENCH
               multi_stream_allocations/multi_stream_allocations_bench.cu)