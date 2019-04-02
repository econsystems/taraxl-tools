#include <iostream>
#include <ctime>
#include  <iomanip>
#include <sys/time.h>

#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

#include "TaraXL.h"
#include "TaraXLCam.h"
#include "TaraXLDepth.h"

using namespace std;
using namespace cv;
using namespace TaraXLSDK;

int main () {

  TaraXL taraxlCam;
  TaraXLCam selectedCam;
  TaraXLCamList taraxlCamList;
  ResolutionList supportedResolutions;
  TaraXLDepth *taraxlDepth;

  timeval totalStart, totalEnd;
  float deltaTime = 0, totalTime = 0;

  uint camIndex, iResIndex, iAccuracyMode;
  TARAXL_STATUS_CODE status;

  status = taraxlCam.enumerateDevices(taraxlCamList);
  if (status != TARAXL_SUCCESS) {

      cout << "Camera enumeration failed" << endl;
      return 1;
  }

  if (taraxlCamList.size() == 0) {

    cout << "No cameras connected" << endl;
    return 1;
  }

  cout << "Select a device:" << endl;
  for (int i = 0; i < taraxlCamList.size(); i++) {

    cout << i << ": ";
    string name;
    taraxlCamList[i].getFriendlyName(name);
    cout << name << endl;
  }

  cin >> camIndex;
  if (cin.fail()) {

    cout << "Invalid input" << endl;
    return 1;
  }

  if (camIndex >= taraxlCamList.size()) {

    cout << "Invalid input" << endl;
    return 1;
  }

  selectedCam = taraxlCamList.at(camIndex);

  status = selectedCam.connect();
  if (status != TARAXL_SUCCESS) {

      cout << "Camera connect failed" << endl;
      return 1;
  }

  status = selectedCam.getResolutionList(supportedResolutions);
  if (status != TARAXL_SUCCESS) {

      cout << "Get camera resolutions failed" << endl;
      return 1;
  }

  cout << endl << "Select a resolution:" << endl;
  for (int i = 0; i < supportedResolutions.size(); i++) {

    cout << i << ": ";
    string resolution = "";
    resolution += to_string(supportedResolutions[i].width);
    resolution += " x ";
    resolution += to_string(supportedResolutions[i].height);
    cout << resolution << endl;
  }
  cin >> iResIndex;

  if (cin.fail()) {

    cout << "Invalid input" << endl;
    return 1;
  }

  if (iResIndex >= supportedResolutions.size()) {

    cout << "Invalid input" << endl;
    return 1;
  }

  status = selectedCam.setResolution(supportedResolutions.at(iResIndex));
  if (status != TARAXL_SUCCESS) {

      cout << "Set resolutions failed" << endl;
      return 1;
  }

  taraxlDepth = new TaraXLDepth(selectedCam);
  if (taraxlDepth == NULL) {

    cout << "Unable to create instance to TaraDepth" << endl;
    return 1;
  }

  cout << endl << "Select a Accuracy mode:" << endl;
  cout << "0: High Accuracy" << endl <<"1: Low Accuracy "<<endl<<"2: Ultra Accuracy" << endl;
  cin >> iAccuracyMode;

  if (cin.fail()) {

    cout << "Invalid input" << endl;
    return 1;
  }

  if (iAccuracyMode == 0) {

    status = taraxlDepth->setAccuracy(HIGH);
  }
  else if (iAccuracyMode == 1) {

    status = taraxlDepth->setAccuracy(LOW);
  }
  else if (iAccuracyMode == 2) {

    status = taraxlDepth->setAccuracy(ULTRA);
  }

  else {

    cout << "Invalid input" << endl;
    return 1;
  }

  if (status != TARAXL_SUCCESS) {

      cout << "Set accuracy failed" << endl;
  }

  Mat left, right, grayDisp, colorDisp, depthMap;
 
  while(totalTime < 2.0f)
  {
        gettimeofday(&totalStart, 0);

      status = taraxlDepth->getMap(left, right, grayDisp, true, depthMap, true, TARAXL_DEFAULT_FILTER);
      if (status != TARAXL_SUCCESS) {

        cout << "Get map failed" << endl;
        delete taraxlDepth;
        return 1;
      }
 
      gettimeofday(&totalEnd, 0);
      deltaTime = (float)(totalEnd.tv_sec - totalStart.tv_sec + (totalEnd.tv_usec - totalStart.tv_usec) * 1e-6);
      totalTime += deltaTime;
  }

  grayDisp.convertTo(grayDisp,CV_8U);
  applyColorMap(grayDisp, colorDisp, COLORMAP_JET);

  imwrite("../left.jpg", left);
  imwrite("../right.jpg", right);
  imwrite("../grayDisparity.jpg", grayDisp);
  imwrite("../colorDisparity.jpg", colorDisp);
  imwrite("../depthMap.jpg", depthMap);

  cout << endl << "Images saved to the disk!!!!" << endl;

  delete taraxlDepth;
  selectedCam.disconnect();
  exit(0);
}
