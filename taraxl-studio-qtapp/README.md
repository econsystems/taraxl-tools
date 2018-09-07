# TaraXL Studio – A Qt Application using TaraXL SDK

This tool outputs the camera left and right images, disparity map and depth map. Also allows to adjust camera and algorithm settings.

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
    cd taraxl-tools/taraxl-studio-qtapp
    qmake
    make

## Run the program

To run the TaraXL Studio application, connect the TaraXL camera to TX2 device and execute the following command

    sudo ./taraXLStudio
