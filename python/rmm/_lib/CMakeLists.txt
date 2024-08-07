# =============================================================================
# Copyright (c) 2022, NVIDIA CORPORATION.
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

set(cython_sources device_buffer.pyx lib.pyx logger.pyx memory_resource.pyx cuda_stream.pyx
                   torch_allocator.pyx)
set(linked_libraries rmm::rmm)

# Build all of the Cython targets
rapids_cython_create_modules(SOURCE_FILES "${cython_sources}" LINKED_LIBRARIES "${linked_libraries}"
                                                                               CXX)
# The cdef public functions in this file need to have a C ABI
target_compile_definitions(torch_allocator PRIVATE CYTHON_EXTERN_C=extern\ "C")
