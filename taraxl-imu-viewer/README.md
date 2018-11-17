# TaraXL IMU – An IMU application using TaraXL SDK

TaraXL SDK provides high level APIs to get values from accelerometer and gyroscope. This tool retrieves pose data from the inbuilt IMU sensor and a simple graph is plotted to visualize the IMU values.

## Prerequisites

- Ubuntu 16.04
- TaraXL SDK
- Cuda9.0

## Getting started

1. Download the latest version of the TaraXL SDK at https://developer.e-consystems.com
2. Install the TaraXL SDK on NVIDIA TX2 device.

## Build the application

Open a terminal and build the package:

    git clone https://github.com/econsystems/taraxl-tools.git
    cd taraxl-tools/taraxl-imu-viewer
    export QT_SELECT=5
    qmake
    make

## Run the program

To run the TaraXL pointcloud application, connect the TaraXL camera to device and execute the following command

    ./taraxlIMU

