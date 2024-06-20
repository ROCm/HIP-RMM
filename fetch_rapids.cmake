# =============================================================================
# Copyright (c) 2023, NVIDIA CORPORATION.
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

if(NOT EXISTS ${CMAKE_CURRENT_BINARY_DIR}/RMM_RAPIDS.cmake)
  if (DEFINED ENV{RAPIDS_CMAKE_BRANCH})
    set(RAPIDS_CMAKE_BRANCH "$ENV{RAPIDS_CMAKE_BRANCH}")
  else()
    set(RAPIDS_CMAKE_BRANCH hipdf-dev)
  endif()

  # TODO(HIP/AMD): once rapids-cmake is publically available for HIP, we can remove the authentication needed here
  set(URL "https://$ENV{GITHUB_USER}:$ENV{GITHUB_PASS}@raw.githubusercontent.com/AMD-AI/rapids-cmake/${RAPIDS_CMAKE_BRANCH}/RAPIDS.cmake")
  file(DOWNLOAD ${URL}
       ${CMAKE_CURRENT_BINARY_DIR}/RMM_RAPIDS.cmake
       STATUS DOWNLOAD_STATUS
  )
  list(GET DOWNLOAD_STATUS 0 STATUS_CODE)
  list(GET DOWNLOAD_STATUS 1 ERROR_MESSAGE)

  if(${STATUS_CODE} EQUAL 0)
    message(STATUS "Downloaded 'RMM_RAPIDS.cmake' successfully!")
  else()
    file(REMOVE ${CMAKE_CURRENT_BINARY_DIR}/RMM_RAPIDS.cmake)
    # for debuging: message(FATAL_ERROR "Failed to download 'RMM_RAPIDS.cmake'. URL: ${URL}, Reason: ${ERROR_MESSAGE}")
    message(FATAL_ERROR "Failed to download 'RMM_RAPIDS.cmake'. Reason: ${ERROR_MESSAGE}")
  endif()
endif()
include(${CMAKE_CURRENT_BINARY_DIR}/RMM_RAPIDS.cmake)
