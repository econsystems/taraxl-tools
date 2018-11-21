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

