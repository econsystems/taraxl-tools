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
#include<thread>
using namespace std;
using namespace cv;
using namespace TaraXLSDK;

std::thread lut1,lut2,lut3;

void lutR(Mat disp0,Mat lookUpTable_R,Mat &cdr)
{
  LUT(disp0,lookUpTable_R , cdr);
}

void lutG(Mat disp0,Mat lookUpTable_G,Mat &cdg)
{
  LUT(disp0,lookUpTable_G , cdg);
}

void lutB(Mat disp0,Mat lookUpTable_B,Mat &cdb)
{
  LUT(disp0,lookUpTable_B , cdb);
}


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
  Mat cdr, cdg, cdb;
  //COLORMAP JET LUT

  uchar r[] = {128,136,144,152,160,168,176,184,192,200,208,216,224,232,240,248,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,254,246,238,230,222,214,206,198,190,182,174,166,158,150,142,134,126,118,110,102,94,86,78,70,62,54,46,38,30,22,14,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

  uchar g[] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,16,24,32,40,48,56,64,72,80,88,96,104,112,120,128,136,144,152,160,168,176,184,192,200,208,216,224,232,240,248,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,252,244,236,228,220,212,204,196,188,180,172,164,156,148,140,132,124,116,108,100,92,84,76,68,60,52,44,36,28,20,12,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

  uchar b[] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,10,18,26,34,42,50,58,66,74,82,90,98,106,114,122,130,138,146,154,162,170,178,186,194,202,210,218,226,234,242,250,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,252,244,236,228,220,212,204,196,188,180,172,164,156,148,140,132};

  int minDisp,maxDisp;
  taraxlDepth->getMinDisparity(minDisp);
  taraxlDepth->getMaxDisparity(maxDisp);

  uchar r1[256],g1[256],b1[256];

  for(int i = 0; i < 256 ; i++)
  {
        if(iAccuracyMode == 0)
        {
                if(i < 64)
                {
                        r1[i] = r1[i+1] = r[i];
                        g1[i] = g1[i+1] = g[i];
                        b1[i] = b1[i+1] = b[i];
                        i++;
                }
                else
                {
                        r1[i] = r[i-32];
                        g1[i] = g[i-32];
                        b1[i] = b[i-32];
                }
        }
        else
        {
                if(i <= minDisp)
                {
                        r1[i] = 0;
                        g1[i] = 0;
                        b1[i] = 0;
                }
                else
                {
                        r1[i] = r[i-minDisp];
                        g1[i] = g[i-minDisp];
                        b1[i] = b[i-minDisp];
                }
        }
  }

  Mat lookUpTable_R(1, 256, CV_8U,&r1), lookUpTable_G(1, 256, CV_8U,&g1), lookUpTable_B(1, 256, CV_8U,&b1);

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
  if(lut3.joinable())
  lut3.join();
  if(lut2.joinable())
  lut2.join();
  if(lut1.joinable())
  lut1.join();

  lut3 = std::thread(lutB, grayDisp,lookUpTable_B, std::ref(cdb));
  lut1 = std::thread(lutR, grayDisp,lookUpTable_R,std::ref(cdr));
  lut2 = std::thread(lutG, grayDisp,lookUpTable_G,std::ref( cdg));
  std::vector<cv::Mat> planes;
  if(lut3.joinable())
  lut3.join();
  planes.push_back(cdb);
  if(lut2.joinable())
  lut2.join();
  planes.push_back(cdg);
  if(lut1.joinable())
  lut1.join();
  planes.push_back(cdr);
  cv::merge(planes,colorDisp);

  cv::cvtColor(colorDisp, colorDisp, CV_RGBA2BGRA);

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
