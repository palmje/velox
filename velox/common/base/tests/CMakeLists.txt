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

add_executable(
  velox_base_test
  AsyncSourceTest.cpp
  BitUtilTest.cpp
  BloomFilterTest.cpp
  CoalesceIoTest.cpp
  ExceptionTest.cpp
  FsTest.cpp
  RangeTest.cpp
  RawVectorTest.cpp
  ScopedLockTest.cpp
  SemaphoreTest.cpp
  SimdUtilTest.cpp
  StatsReporterTest.cpp
  SuccinctPrinterTest.cpp)

add_test(velox_base_test velox_base_test)

target_link_libraries(
  velox_base_test
  velox_common_base
  ${gflags_LIBRARIES}
  glog::glog
  gtest
  gtest_main
  pthread)

add_executable(velox_memcpy_meter Memcpy.cpp)
target_link_libraries(velox_memcpy_meter velox_common_base pthread)
