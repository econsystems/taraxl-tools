
cmake_minimum_required(VERSION 2.4)
project(sample)
include(${CMAKE_ROOT}/Modules/ExternalProject.cmake)

if(COMMAND cmake_policy)
    cmake_policy(SET CMP0003 NEW)
endif(COMMAND cmake_policy)


set(OUTPUT "PCLSample")
set(CMAKE_BUILD_TYPE Release)

#find required Packages
find_package( OpenCV REQUIRED HINTS /usr/local/taraxl-opencv/)
find_package( CUDA REQUIRED )
find_package(PCL 1.8 REQUIRED HINTS "/usr/local/taraxl-pcl")
find_package(PkgConfig REQUIRED)
pkg_search_module(GLIB REQUIRED glib-2.0)

set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -Wno-deprecated-declarations -std=c++11")
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

#set INCLUDE PATHS
set(TARA_HEADER_DIR "/usr/local/taraxl-sdk/include/")

#set LIBRARY PATHS
set(TARA_LIB_DIR "/usr/local/taraxl-sdk/lib/")


#add_dependencies (tara_sdk)

include_directories (${OpenCV_INCLUDE_DIRS})
include_directories (${TARA_HEADER_DIR})
include_directories (${PCL_INCLUDE_DIRS})
include_directories (${GLIB_INCLUDE_DIRS})

link_directories (${TARA_LIB_DIR})
link_directories (${PCL_LIBRARY_DIRS})

add_definitions(${PCL_DEFINITIONS})

set_directory_properties( PROPERTIES COMPILE_DEFINITIONS "" )

cuda_add_executable(PCLSample PCLSample.cu)

target_link_libraries(  PCLSample
			${GLIB_LIBS}
			${CUDA_LIBS}
			${OpenCV_LIBS}
		        ${PCL_LIBRARIES}
			libecon_taraxl.so
			)
