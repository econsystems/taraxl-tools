# TaraXL Pointcloud – A pointcloud application using TaraXL SDK

This tool retrieves pointcloud using TaraXL APIs and displays it in a pointcloud viewer. Shortcuts are available to toggle between various qualities that TaraXL SDK provides.

## Prerequisites

- Ubuntu 16.04/18.04
- TaraXL SDK
- Cuda9.0/10.0

## Getting started

1. Download the latest version of the TaraXL SDK at https://developer.e-consystems.com
2. Install the TaraXL SDK on NVIDIA TX2/Xavier/Nano/ Ubuntu x86 PC device.

## Build the application

Open a terminal and build the package:

    git clone https://github.com/econsystems/taraxl-tools.git
    cd taraxl-tools/taraxl-pointcloud-app
    mkdir build && cd build
    cmake ../.
    make

## Run the program

To run the TaraXL pointcloud application, connect the TaraXL camera to device and execute the following command

For Ubuntu x86 PC  : 

    sudo ./taraxlpointcloudviewer
For NVIDIA Jetson TX2/Xavier/Nano : 

    ./taraxlpointcloudviewer

## Troubleshooting
1. The following error occurs when compiling the sample applications using CUDA 9.0 :

        In file included from /usr/local/cuda-9.0/include/common_functions.h:50:0,
                     from /usr/local/cuda-9.0/include/cuda_runtime.h:115,
                     from <command-line>:0:
        /usr/local/cuda-9.0/include/crt/common_functions.h:64:24: error: token ""__CUDACC_VER is no longer supported.  Use CUDACC_VER_MAJOR, CUDACC_VER_MINOR, and CUDACC_VER_BUILD__ instead."" is not valid in preprocessor expressions
        #define CUDACC_VER "__CUDACC_VER is no longer supported.  Use CUDACC_VER_MAJOR, CUDACC_VER_MINOR, and CUDACC_VER_BUILD__ instead."
    
    and the following when using CUDA 10.0 : 
    
            In file included from /usr/local/cuda/include/cuda_runtime.h:120:0,
                         from <command-line>:0:
        /usr/local/cuda/include/crt/common_functions.h:74:24: error: token ""__CUDACC_VER__ is no longer supported.  Use __CUDACC_VER_MAJOR__, __CUDACC_VER_MINOR__, and __CUDACC_VER_BUILD__ instead."" is not valid in preprocessor expressions
         #define __CUDACC_VER__ "__CUDACC_VER__ is no longer supported.  Use __CUDACC_VER_MAJOR__, __CUDACC_VER_MINOR__, and __CUDACC_VER_BUILD__ instead."
                                ^
        /usr/local/cuda/include/crt/common_functions.h:74:24: error: token ""__CUDACC_VER__ is no longer supported.  Use __CUDACC_VER_MAJOR__, __CUDACC_VER_MINOR__, and __CUDACC_VER_BUILD__ instead."" is not valid in preprocessor expressions
         #define __CUDACC_VER__ "__CUDACC_VER__ is no longer supported.  Use __CUDACC_VER_MAJOR__, __CUDACC_VER_MINOR__, and __CUDACC_VER_BUILD__ instead."
                                ^
        /usr/local/cuda/include/crt/common_functions.h:74:24: error: token ""__CUDACC_VER__ is no longer supported.  Use __CUDACC_VER_MAJOR__, __CUDACC_VER_MINOR__, and __CUDACC_VER_BUILD__ instead."" is not valid in preprocessor expressions
         #define __CUDACC_VER__ "__CUDACC_VER__ is no longer supported.  Use __CUDACC_VER_MAJOR__, __CUDACC_VER_MINOR__, and __CUDACC_VER_BUILD__ instead."
                                ^
        /usr/local/cuda/include/crt/common_functions.h:74:24: error: token ""__CUDACC_VER__ is no longer supported.  Use __CUDACC_VER_MAJOR__, __CUDACC_VER_MINOR__, and __CUDACC_VER_BUILD__ instead."" is not valid in preprocessor expressions
         #define __CUDACC_VER__ "__CUDACC_VER__ is no longer supported.  Use __CUDACC_VER_MAJOR__, __CUDACC_VER_MINOR__, and __CUDACC_VER_BUILD__ instead."
                                ^
        /usr/local/cuda/include/crt/common_functions.h:74:24: error: token ""__CUDACC_VER__ is no longer supported.  Use __CUDACC_VER_MAJOR__, __CUDACC_VER_MINOR__, and __CUDACC_VER_BUILD__ instead."" is not valid in preprocessor expressions
         #define __CUDACC_VER__ "__CUDACC_VER__ is no longer supported.  Use __CUDACC_VER_MAJOR__, __CUDACC_VER_MINOR__, and __CUDACC_VER_BUILD__ instead."
    It occurs when compiling boost/eigen along with cuda. You need to update the boost/eigen libraries or try commenting out this line :
        
        #define CUDACC_VER "__CUDACC_VER is no longer supported.  Use CUDACC_VER_MAJOR, CUDACC_VER_MINOR, and CUDACC_VER_BUILD__ instead."
        
    in /usr/local/cuda-9.0/include/crt/common_functions.h while compiling with CUDA 9.0 and in /usr/local/cuda/include/crt/common_functions.h while compiling with CUDA 10.0.

2. The following error occurs while running make in TX2:

        /usr/lib/gcc/aarch64-linux-gnu/5/../../../aarch64-linux-gnu/libGL.so: undefined reference to draGetDevices2
        /usr/lib/gcc/aarch64-LInux-gnu/5/../../../aarch64-Linux-gnu/llbGL.so: undefined reference to drncloseonce 
        /usr/lib/gcc/aarch64-linux-gnu/5/../../../aarch64-l1nux-gnu/ltbGL.So: undefined reference to draMap 
        /usr/lib/gcc/aarch64-linux-gnu/5/../../../aarch64-linux-gnu/libGL.so: undefined reference to drmunnap
        /usr/lib/gcc/aarch64-1lnux-gnu/5/../../../aarch64-1tnux-gnu/llbGL.so: undefined reference to draFreebevice
        /usr/lib/gcc/aarch64-linux-gnu/5/../../../aarch64-linux-gnu/llbGL.so: undefined reference to drnGetDeviceNaneFromFd2
        /usr/lib/gcc/aarch64-linux-gnu/5/../../../aarch64-Ilnux-gnu/llbGL.so: undefined reference to draGetDevice2
        /usr/lib/gcc/aarch64-linux-gnu/5/../../../aarch64-linux-gnu/libGL.so: undefined reference to drnFreeDevices
    This happens sometimes, due to some erroneous intallation of cuda in TX2. To troubleshoot this, please link the libGL libraries manually as given below :
    
        cd /usr/lib/aarch64-linux-gnu/
        sudo ln -sf tegra/libGL.so libGL.so
3. The following error occurs while using CUDA 10

        In file included from /usr/include/eigen3/Eigen/StdVector:14:0,
                     from /usr/local/taraxl-pcl/include/pcl-1.8/pcl/pcl_base.h:49,
                     from /usr/local/taraxl-pcl/include/pcl-1.8/pcl/common/common.h:41,
                     from /usr/local/taraxl-pcl/include/pcl-1.8/pcl/common/common_headers.h:39,
                     from /usr/local/taraxl-sdk/include/TaraXLPointcloud.h:22,
                     from /home/nvidia/Desktop/taraxl-tools/taraxl-pointcloud-app/PCLSample.cu:9:
        /usr/include/eigen3/Eigen/Core:42:14: fatal error: math_functions.hpp: No such file or directory
         #include <math_functions.hpp>
                  ^~~~~~~~~~~~~~~~~~~~
        compilation terminated.
    It occurs when compiling boost/eigen along with cuda 10.0. You need to update the boost/eigen libraries or try commenting out this line in "/usr/include/eigen3/Eigen/Core" (line number 42)
    
            #include <math_functions.hpp>
            
    and add the below line :

            #include <cuda_runtime.h>

4. When the scene is not visible in the application sometimes, Press Alt + r to reset the actual view. 
