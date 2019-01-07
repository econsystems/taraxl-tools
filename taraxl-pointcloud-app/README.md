# TaraXL Pointcloud – A pointcloud application using TaraXL SDK

This tool retrieves pointcloud using TaraXL APIs and displays it in a pointcloud viewer. Shortcuts are available to toggle between various qualities that TaraXL SDK provides.

## Prerequisites

- Ubuntu 16.04
- TaraXL SDK
- Cuda9.0

## Getting started

1. Download the latest version of the TaraXL SDK at https://developer.e-consystems.com
2. Install the TaraXL SDK on NVIDIA TX2/ Ubuntu x86 PC device.

## Build the application

Open a terminal and build the package:

    git clone https://github.com/econsystems/taraxl-tools.git
    cd taraxl-tools/taraxl-pointcloud-app
    mkdir build && cd build
    cmake ../.
    make

## Run the program

To run the TaraXL pointcloud application, connect the TaraXL camera to device and execute the following command

    sudo ./PCLSample

## Troubleshooting
1. The following error occurs when compiling the sample applications :

        In file included from /usr/local/cuda-9.0/include/common_functions.h:50:0,
                     from /usr/local/cuda-9.0/include/cuda_runtime.h:115,
                     from <command-line>:0:
        /usr/local/cuda-9.0/include/crt/common_functions.h:64:24: error: token ""__CUDACC_VER is no longer supported.  Use CUDACC_VER_MAJOR, CUDACC_VER_MINOR, and CUDACC_VER_BUILD__ instead."" is not valid in preprocessor expressions
        #define CUDACC_VER "__CUDACC_VER is no longer supported.  Use CUDACC_VER_MAJOR, CUDACC_VER_MINOR, and CUDACC_VER_BUILD__ instead."
    
    It occurs when compiling boost/eigen along with cuda. You need to update the boost/eigen libraries or try commenting out this line :
        
        #define CUDACC_VER "__CUDACC_VER is no longer supported.  Use CUDACC_VER_MAJOR, CUDACC_VER_MINOR, and CUDACC_VER_BUILD__ instead."
    in /usr/local/cuda-9.0/include/crt/common_functions.h.

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
