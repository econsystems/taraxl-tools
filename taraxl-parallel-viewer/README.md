# TaraXL Parallel viewer – A sample console application using TaraXL SDK for parallel video streams

This tool lets you build and run a sample console application using TaraXL SDK. The app streams the depth images of all the connected cameras and runs it parallely.

## Prerequisites

- Ubuntu 16.04/Ubuntu 18.04
- TaraXL SDK
- Cuda9.0/10.0

## Getting started

1. Download the latest version of the TaraXL SDK at https://developer.e-consystems.com
2. Install the TaraXL SDK on NVIDIA TX2/Xavier device/Nano device/Ubuntu x86 PC.

## Build the application

Open a terminal and build the package:

    git clone https://github.com/econsystems/taraxl-tools.git
    cd taraxl-tools/taraxl-parallel-viewer
    mkdir build && cd build
    cmake ../.
    make

## Run the program

To run the TaraXL parallel viewer application, connect the TaraXL camera to device/PC and execute the following command

For Ubuntu x86 PC : 

    sudo ./taraxlparallelviewer
For NVIDIA Jetson boards : 

    ./taraxlparallelviewer
