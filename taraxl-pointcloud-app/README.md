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

    ./PCLViewer

## Troubleshooting
The following error occurs when compiling the sample application :

    In file included from /usr/local/cuda-9.0/include/common_functions.h:50:0,
                 from /usr/local/cuda-9.0/include/cuda_runtime.h:115,
                 from <command-line>:0:
    /usr/local/cuda-9.0/include/crt/common_functions.h:64:24: error: token ""__CUDACC_VER is no longer supported.  Use CUDACC_VER_MAJOR, CUDACC_VER_MINOR, and CUDACC_VER_BUILD__ instead."" is not valid in preprocessor expressions
    #define CUDACC_VER "__CUDACC_VER is no longer supported.  Use CUDACC_VER_MAJOR, CUDACC_VER_MINOR, and CUDACC_VER_BUILD__ instead."

It occurs when compiling boost/eigen along with cuda. You need to update the boost/eigen libraries or try commenting out this line :
    
    #define CUDACC_VER "__CUDACC_VER is no longer supported.  Use CUDACC_VER_MAJOR, CUDACC_VER_MINOR, and CUDACC_VER_BUILD__ instead."
in /usr/local/cuda-9.0/include/crt/common_functions.h.

