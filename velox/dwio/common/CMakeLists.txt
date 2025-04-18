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
add_subdirectory(compression)
add_subdirectory(encryption)
add_subdirectory(exception)

if(${VELOX_BUILD_TESTING})
  add_subdirectory(tests)
elseif(${VELOX_BUILD_TEST_UTILS})
  add_subdirectory(tests/utils)
endif()

add_library(
  velox_dwio_common
  BitConcatenation.cpp
  BitPackDecoder.cpp
  BufferedInput.cpp
  CachedBufferedInput.cpp
  CacheInputStream.cpp
  ColumnSelector.cpp
  Common.cpp
  DataSink.cpp
  DecoderUtil.cpp
  DirectDecoder.cpp
  DwioMetricsLog.cpp
  FlatMapHelper.cpp
  InputStream.cpp
  IntDecoder.cpp
  IoStatistics.cpp
  MemoryInputStream.cpp
  MetadataFilter.cpp
  Options.cpp
  Range.cpp
  ReaderFactory.cpp
  ScanSpec.cpp
  ColumnLoader.cpp
  SelectiveByteRleColumnReader.cpp
  SelectiveColumnReader.cpp
  SelectiveRepeatedColumnReader.cpp
  SelectiveStructColumnReader.cpp
  SeekableInputStream.cpp
  TypeUtils.cpp
  TypeWithId.cpp)

target_link_libraries(
  velox_dwio_common
  velox_buffer
  velox_caching
  velox_dwio_common_compression
  velox_dwio_common_encryption
  velox_dwio_common_exception
  velox_exception
  velox_expression
  velox_memory
  Boost::regex
  ${FOLLY_WITH_DEPENDENCIES}
  glog::glog)
