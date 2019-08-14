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
  TaraXLCamList taraxlCamList;
  ResolutionList supportedResolutions;
  ACCURACY_MODE selectedMode;

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
  cout << endl << "Select a Accuracy mode:" << endl;
   cout << "0: High Accuracy" << endl <<"1: Low Accuracy "<<endl<<"2: Ultra Accuracy" << endl;
   cin >> iAccuracyMode;

   if (cin.fail()) {

     cout << "Invalid input" << endl;
     return 1;
   }

   if (iAccuracyMode == 0) {

     selectedMode = HIGH;
   }
   else if (iAccuracyMode == 1) {

     selectedMode = LOW;
   }
   else if (iAccuracyMode == 2) {

     selectedMode = ULTRA;
   }

   else {

     cout << "Invalid input" << endl;
     return 1;
   }

  vector<Ptr<TaraXLDepth> > taraxlDepthList;
  vector<Mat> left, right, grayDisp, colorDisp, depthMap;
  TaraXLCam *selectedCam;
  for(int i = 0 ; i < taraxlCamList.size() ; i++)
  {
	  selectedCam = new TaraXLCam(taraxlCamList.at(i));
	  status = selectedCam->connect();
	  if (status != TARAXL_SUCCESS) {

	      cout << "Camera connect failed " << status << endl;
	      return 1;
	  }
	  Ptr<TaraXLDepth> depth;
	  cout << "Camera connect status" << status << endl;
	  depth = new TaraXLDepth(*selectedCam);
  	  if (depth == NULL)
	  {
    		cout << "Unable to create instance to TaraDepth" << endl;
    		return 1;
  	  }
	  depth->setAccuracy(selectedMode);
	  taraxlDepthList.push_back(depth);
          string id;
          selectedCam->getCameraUniqueId(id);
	  string windowName = "CAMERA : "+ id;
	  namedWindow(windowName, CV_WINDOW_AUTOSIZE);

	  Mat sample;
	  left.push_back(sample);
	  right.push_back(sample);
	  grayDisp.push_back(sample);
	  colorDisp.push_back(sample);
	  depthMap.push_back(sample);
  }

  Mat cdr, cdg, cdb;
  //COLORMAP JET LUT

  uchar r[] = {128,136,144,152,160,168,176,184,192,200,208,216,224,232,240,248,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,254,246,238,230,222,214,206,198,190,182,174,166,158,150,142,134,126,118,110,102,94,86,78,70,62,54,46,38,30,22,14,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

  uchar g[] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,16,24,32,40,48,56,64,72,80,88,96,104,112,120,128,136,144,152,160,168,176,184,192,200,208,216,224,232,240,248,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,252,244,236,228,220,212,204,196,188,180,172,164,156,148,140,132,124,116,108,100,92,84,76,68,60,52,44,36,28,20,12,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

  uchar b[] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,10,18,26,34,42,50,58,66,74,82,90,98,106,114,122,130,138,146,154,162,170,178,186,194,202,210,218,226,234,242,250,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,252,244,236,228,220,212,204,196,188,180,172,164,156,148,140,132};

  Mat lookUpTable_R(1, 256, CV_8U,&r), lookUpTable_G(1, 256, CV_8U,&g), lookUpTable_B(1, 256, CV_8U,&b);
  while(1)
  {
	for(int i = 0 ; i < taraxlCamList.size() ; i++)
	{

		status = taraxlDepthList.at(i)->getMap(left.at(i), right.at(i), grayDisp.at(i), true, depthMap.at(i), false, TARAXL_DEFAULT_FILTER);
		if (status != TARAXL_SUCCESS)
		{
			cout << "Get map failed" << endl;
			delete taraxlDepthList.at(i);
		        return 1;
		}
		grayDisp.at(i).convertTo(grayDisp.at(i),CV_8U);


    if(lut3.joinable())
    lut3.join();
    if(lut2.joinable())
    lut2.join();
    if(lut1.joinable())
    lut1.join();

    lut3 = std::thread(lutB, grayDisp.at(i),lookUpTable_B, std::ref(cdb));
    lut1 = std::thread(lutR, grayDisp.at(i),lookUpTable_R,std::ref(cdr));
    lut2 = std::thread(lutG, grayDisp.at(i),lookUpTable_G,std::ref( cdg));
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
    cv::merge(planes,colorDisp.at(i));

    cv::cvtColor(colorDisp.at(i), colorDisp.at(i), CV_RGBA2BGRA);
    string id;
    taraxlCamList.at(i).getCameraUniqueId(id);


		string windowName = "CAMERA : "+ id;
		imshow(windowName, colorDisp.at(i));
		waitKey(1);
	}
  }
  exit(0);
}
