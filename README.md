## Introduction to TaraXL

The TaraXL - See3CAM_StereoA is a UVC compliant USB 3.0 SuperSpeed Stereo vision camera from e-con Systems, a leading embedded Product Design Services company which specializes in the advanced camera solutions.

For More Information please visit:
https://www.e-consystems.com/3d-usb-stereo-camera-with-nvidia-accelerated-sdk.asp

## Contents

The taraxl tools demonstrates the API feature and code.
1. **taraxl-studio-qtapp** – With this tool you can quickly access the depth map, configure brightness and exposure settings, modify algorithm settings and much more.
2. **console-savedepth-app** – With this tool you can quickly save the depth map in a image format.
3. **taraxl-pointcloud-app** - With this tool, you can view and save the different qualities of pointclouds.
4. **taraxl-imu-viewer** - This tools helps you to view the IMU values in a graphical format.

## Getting started

1. Download the latest version of the TaraXL SDK at https://developer.e-consystems.com
2. Install the TaraXL SDK on you NVIDIA TX2 device.

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
## Support

If you need assistance with the TaraXL, visit at https://www.e-consystems.com/Request-form.asp?paper=see3cam_stereoa or contact us at techsupport@e-consystems.com
