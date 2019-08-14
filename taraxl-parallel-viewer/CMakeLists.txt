
cmake_minimum_required(VERSION 2.4)
project(sample)
include(${CMAKE_ROOT}/Modules/ExternalProject.cmake)

if(COMMAND cmake_policy)
    cmake_policy(SET CMP0003 NEW)
endif(COMMAND cmake_policy)


set(OUTPUT "taraxlparallelviewer")
set(CMAKE_BUILD_TYPE Release)

#find required Packages
find_package( OpenCV REQUIRED HINTS /usr/local/taraxl-opencv/)
find_package( CUDA REQUIRED )
find_package(PkgConfig REQUIRED)
pkg_search_module(GLIB REQUIRED glib-2.0)

set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -Wno-deprecated-declarations -std=c++11")
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

#set INCLUDE PATHS
set(TARA_HEADER_DIR "/usr/local/taraxl-sdk/include/")

#set LIBRARY PATHS
#set(TARA_LIB_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../common/tara/build/")
set(TARA_LIB_DIR "/usr/local/taraxl-sdk/lib/")

#add_subdirectory(${TARA_LIB_DIR}../ ${TARA_LIB_DIR})

#ExternalProject_add(tara_sdk
#    SOURCE_DIR ${TARA_LIB_DIR}../
#    BINARY_DIR ${TARA_LIB_DIR}
#)

#add_dependencies (tara_sdk)

include_directories (${OpenCV_INCLUDE_DIRS})
include_directories (${TARA_HEADER_DIR})
include_directories (${GLIB_INCLUDE_DIRS})

link_directories (${TARA_LIB_DIR})

cuda_add_executable(taraxlparallelviewer taraxlparallelviewer.cu)

target_link_libraries(  taraxlparallelviewer
			${GLIB_LIBS}
			${CUDA_LIBS}
			${OpenCV_LIBS}
			libecon_taraxl.so
			)
