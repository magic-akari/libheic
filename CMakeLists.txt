cmake_minimum_required(VERSION 3.21)

project(libheic)

set(CMAKE_CXX_STANDARD 17)
enable_language(OBJCXX)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "MinSizeRel")
endif()

set(CMAKE_OSX_ARCHITECTURES "arm64;x86_64" CACHE STRING "" FORCE)
set(CMAKE_OSX_DEPLOYMENT_TARGET "10.13")

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS}")

# main
add_library(${PROJECT_NAME} SHARED
  ${PROJECT_SOURCE_DIR}/src/lib.mm
  ${PROJECT_SOURCE_DIR}/src/libheic.mm
)

# set filename
set_target_properties(
  ${PROJECT_NAME} PROPERTIES
  OUTPUT_NAME "libheic.node"
  PREFIX ""
  SUFFIX ""
)

target_include_directories(
  ${PROJECT_NAME} PUBLIC
  ${PROJECT_SOURCE_DIR}/node_modules/node-addon-api
  ${PROJECT_SOURCE_DIR}/node_modules/node-api-headers/include
)

target_link_options(${PROJECT_NAME} PUBLIC -undefined dynamic_lookup)

target_link_libraries(
  ${PROJECT_NAME}
  "-framework Foundation"
  "-framework AVFoundation"
  "-framework ImageIO"
)