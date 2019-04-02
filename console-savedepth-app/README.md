# TaraXL Save Depth – A sample console application using TaraXL SDK

This tool lets you build and run a sample console application using TaraXL SDK on NVIDIA TX2/Xavier. The camera left and right images, disparity map, color disparity map and depth map saved in your device(in jpg format).

## Prerequisites

- Ubuntu 16.04/Ubuntu 18.04
- TaraXL SDK
- Cuda9.0/10.0

## Getting started

1. Download the latest version of the TaraXL SDK at https://developer.e-consystems.com
2. Install the TaraXL SDK on NVIDIA TX2/Xavier device/ Ubuntu x86 PC.

## Build the application

Open a terminal and build the package:

    git clone https://github.com/econsystems/taraxl-tools.git
    cd taraxl-tools/console-savedepth-app
    mkdir build && cd build
    cmake ../.
    make

## Run the program

To run the TaraXL savedepth application, connect the TaraXL camera to TX2/Xavier and execute the following command

For NVIDIA Jetson TX2 : 

    sudo ./taraxlsavedepth
For NVIDIA Jetson Xavier : 

    ./taraxlsavedepth
