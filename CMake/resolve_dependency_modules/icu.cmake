# Copyright (c) Facebook, Inc. and its affiliates.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
include_guard(GLOBAL)

if(DEFINED ENV{VELOX_ICU4C_URL})
  set(ICU4C_SOURCE_URL "$ENV{VELOX_ICU4C_URL}")
else()
  set(VELOX_ICU4C_BUILD_VERSION 72)
  string(
    CONCAT ICU4C_SOURCE_URL
           "https://github.com/unicode-org/icu/releases/download/"
           "release-${VELOX_ICU4C_BUILD_VERSION}-1/"
           "icu4c-${VELOX_ICU4C_BUILD_VERSION}_1-src.tgz")

  set(VELOX_ICU4C_BUILD_SHA256_CHECKSUM
      a2d2d38217092a7ed56635e34467f92f976b370e20182ad325edea6681a71d68)
endif()

message(STATUS "Building ICU4C from source")

ProcessorCount(NUM_JOBS)
set_with_default(NUM_JOBS NUM_THREADS ${NUM_JOBS})
find_program(MAKE_PROGRAM make REQUIRED)

set(ICU_CFG --disable-tests --disable-samples)
set(HOST_ENV_CMAKE
    ${CMAKE_COMMAND}
    -E
    env
    CC="${CMAKE_C_COMPILER}"
    CXX="${CMAKE_CXX_COMPILER}"
    CFLAGS="${CMAKE_C_FLAGS}"
    CXXFLAGS="${CMAKE_CXX_FLAGS}"
    LDFLAGS="${CMAKE_MODULE_LINKER_FLAGS}")
set(ICU_DIR ${CMAKE_CURRENT_BINARY_DIR}/icu)
set(ICU_INCLUDE_DIRS ${ICU_DIR}/include)
set(ICU_LIBRARIES ${ICU_DIR}/lib)

# We can not use FetchContent as ICU does not use cmake
ExternalProject_Add(
  ICU
  URL ${ICU4C_SOURCE_URL}
  URL_HASH SHA256=${VELOX_ICU4C_BUILD_SHA256_CHECKSUM}
  SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/icu-src
  BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/icu-bld
  CONFIGURE_COMMAND <SOURCE_DIR>/source/configure --prefix=${ICU_DIR}
                    --libdir=${ICU_LIBRARIES} ${ICU_CFG}
  BUILD_COMMAND ${MAKE_PROGRAM} -j ${NUM_JOBS}
  INSTALL_COMMAND ${HOST_ENV_CMAKE} ${MAKE_PROGRAM} install)

add_library(ICU::ICU UNKNOWN IMPORTED)
add_dependencies(ICU::ICU ICU-build)
set_target_properties(
  ICU::ICU PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${ICU_INCLUDE_DIRS}
                      INTERFACE_LINK_LIBRARIES ${ICU_LIBRARIES})

# We have to keep the FindICU.cmake in a subfolder to prevent it from overriding
# the system provided one when ICU_SOURCE=SYSTEM
list(PREPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/icu)
