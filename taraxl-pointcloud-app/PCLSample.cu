#include <iostream>

#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

#include "TaraXL.h"
#include "TaraXLCam.h"
#include "TaraXLPointcloud.h"

#include "boost/thread/thread.hpp"
#include <boost/thread/mutex.hpp>
#include "pcl/common/common_headers.h"
#include "pcl/visualization/pcl_visualizer.h"
#include "pcl/visualization/cloud_viewer.h"
#include <pcl/visualization/common/common.h>
using namespace std;
using namespace cv;
using namespace TaraXLSDK;


enum quality{S = 0, M = 1, H = 2 };
enum quality pcl_quality = H;
enum save{PLY = 0, PCD = 1, VTK = 2};
enum save pcl_save = PLY;
int showSaved=0,savePressed=0;
//#define PRINT_TIME

boost::mutex io_mutex;


void viewerOneOff (pcl::visualization::PCLVisualizer& viewer)
{

	viewer.setShowFPS(false);
    viewer.addText("Quality mode : Highest",20,80,15,10,10,255,"mode");
    viewer.addText("Press m/M to change quality",20,60,15,10,10,255,"modeInst");
    viewer.addText("Save format : PLY",20,40,15,10,10,255,"saveFormat");
    viewer.addText("Press n/N to change save format",20,20,15,10,10,255,"saveInst");
    viewer.addText("",20,0,15,10,10,255,"saved");

}


void viewerUpdate (pcl::visualization::PCLVisualizer& viewer)
{

	if(pcl_quality==S)
		viewer.updateText("Quality mode : Standard",20,80,15,10,10,255,"mode");
    if(pcl_quality==M)
        viewer.updateText("Quality mode : Medium",20,80,15,10,10,255,"mode");
    if(pcl_quality==H)
        viewer.updateText("Quality mode : Highest",20,80,15,10,10,255,"mode");


    if(pcl_save==PLY)
		viewer.updateText("Save format : PLY",20,40,15,10,10,255,"saveFormat");
    if(pcl_save==PCD)
        viewer.updateText("Save format : PCD",20,40,15,10,10,255,"saveFormat");
    if(pcl_save==VTK)
        viewer.updateText("Save format : VTK",20,40,15,10,10,255,"saveFormat");

    if(savePressed==1)
    {
		viewer.updateText("Saved",20,0,15,10,10,255,"saved");
	    showSaved++;
     	if(showSaved>10)
     	{
      		savePressed=0; 
      		showSaved=0;
     	}
    }
    
	if(savePressed==0)
    {
		viewer.updateText(" ",20,0,15,10,10,255,"saved");  
    } 
 
}



void keyboardEventOccurred (const pcl::visualization::KeyboardEvent &event,void* taraxl3d_void)
{

	TaraXLPointcloud *taraxl3d = static_cast<TaraXLPointcloud *> (taraxl3d_void);

  	TARAXL_STATUS_CODE status;

  	if ((event.getKeySym () == "M" || event.getKeySym () =="m") && event.keyUp())
  	{
		switch (pcl_quality)
	    {
    		case H:
     		status = taraxl3d->setPointcloudQuality(STANDARD);
     		if (status != TARAXL_SUCCESS)
     		{
      			cout << "Quality set failed" << endl;
      			break ;
     		}
     		pcl_quality = S;
     		break;

     		case M:
     		status = taraxl3d->setPointcloudQuality(HIGHEST);
     		if (status != TARAXL_SUCCESS)
     		{
      			cout << "Quality set failed" << endl;
     			 break ;
     		}
    		pcl_quality = H;
    		break;

     		case S:
     		status = taraxl3d->setPointcloudQuality(MEDIUM);
     		if (status != TARAXL_SUCCESS)
    		{
      			cout << "Quality set failed" << endl;
      			break ;
     		}
     		pcl_quality = M;
     		break;
	}

}


	if ((event.getKeySym () == "N" || event.getKeySym () =="n") && event.keyUp())
 	{
		switch (pcl_save)
   	 	{
			case PLY :
     		pcl_save = PCD;
     		break;

     		case PCD:
     		pcl_save = VTK;
     		break;

     		case VTK:
     		pcl_save = PLY;
     		break;
    	}
 	}


	if ( event.isShiftPressed() && (event.getKeySym () == "S" || event.getKeySym () =="s") && event.keyUp())
 	{
		io_mutex.lock();

		switch(pcl_save)
  		{
			case PLY :
     		status = taraxl3d->savePoints(TARAXL_PLY_CLOUD,"samplePLYCloud.ply"); 
     
     		if (status != TARAXL_SUCCESS)
    		{
      			cout << "Save failed" << endl;
      			break;
     		} 
     		savePressed=1;
     		break;
  

     		case PCD:
			status = taraxl3d->savePoints(TARAXL_PCD_CLOUD,"samplePCDCloud.pcd");
			if (status != TARAXL_SUCCESS)
			{
				cout << "Save failed" << endl;
			 	break;
			}
			savePressed=1;
			break;

			case VTK:
			status = taraxl3d->savePoints(TARAXL_VTK_CLOUD,"sampleVTKCloud.vtk");
			if (status != TARAXL_SUCCESS)
			{
				cout << "Save failed" << endl;
			 	break;
			}
			savePressed=1;
			break;
		 }

		 io_mutex.unlock();

	}

}


int main () 
{

	TaraXL taraxlCam;
  	TaraXLCam selectedCam;
 	TaraXLCamList taraxlCamList;
	ResolutionList supportedResolutions;
	TaraXLPointcloud *taraxl3d;
	pcl::visualization::CloudViewer *g_PclViewer;


	uint camIndex, iResIndex, iAccuracyMode;
	TARAXL_STATUS_CODE status;

	status = taraxlCam.enumerateDevices(taraxlCamList);
  	if (status != TARAXL_SUCCESS) 
	{
		cout << "Camera enumeration failed" << endl;
      	return 1;
  	}

  	if (taraxlCamList.size() == 0) 
	{
		cout << "No cameras connected" << endl;
    	return 1;
  	}

  	cout << "Select a device:" << endl;
  	for (int i = 0; i < taraxlCamList.size(); i++) 
	{
		cout << i << ": ";
    	string name;
    	taraxlCamList[i].getFriendlyName(name);
    	cout << name << endl;
  	}

  	cin >> camIndex;
  	if (cin.fail()) 
	{
		cout << "Invalid input" << endl;
    	return 1;
  	}

  	if (camIndex >= taraxlCamList.size()) 
	{
		cout << "Invalid input" << endl;
    	return 1;
  	}

  	selectedCam = taraxlCamList.at(camIndex);

  	status = selectedCam.connect();
  	if (status != TARAXL_SUCCESS) 
	{
		cout << "Camera connect failed" << endl;
      	return 1;
  	}

  	status = selectedCam.getResolutionList(supportedResolutions);
 	if (status != TARAXL_SUCCESS) 
	{
		cout << "Get camera resolutions failed" << endl;
      	return 1;
  	}

  	cout << endl << "Select a resolution:" << endl;
  	for (int i = 0; i < supportedResolutions.size(); i++) 
	{
		cout << i << ": ";
    	string resolution = "";
    	resolution += to_string(supportedResolutions[i].width);
    	resolution += " x ";
    	resolution += to_string(supportedResolutions[i].height);
    	cout << resolution << endl;
  	}
  	cin >> iResIndex;

  	if (cin.fail()) 
	{
		cout << "Invalid input" << endl;
	    return 1;
  	}

  	if (iResIndex >= supportedResolutions.size()) 
	{
    	cout << "Invalid input" << endl;
    	return 1;
  	}

  	status = selectedCam.setResolution(supportedResolutions.at(iResIndex));
  	if (status != TARAXL_SUCCESS) 
	{
		cout << "Set resolutions failed" << endl;
      	return 1;
  	}

  	taraxl3d = new TaraXLPointcloud(selectedCam);
  	if (taraxl3d == NULL) 
	{
		cout << "Unable to create instance to TaraDepth" << endl;
    	return 1;
  	}

  	cout<< endl << " \nPress m/M to cycle through the quality modes(HIGHEST,MEDIUM,STANDARD)"<<endl;
  	cout<< endl << " \nPress n/N to cycle through the PointCloud save formats(PLY,PCD,VTK)  "<<endl;
  	cout<< endl << " \nPress SHIFT+S to save the PointCloud in the current save format "<<endl;

  	g_PclViewer = new pcl::visualization::CloudViewer("TaraXL Point Cloud  Viewer");

  	Points::Ptr currentCloud (new Points);	

    #ifdef PRINT_TIME
		timeval start, end;
    	float deltatime = 0.0f,fpsTotaltime;
    	unsigned int iFpsFrames = 0;
    #endif

	g_PclViewer->registerKeyboardCallback (keyboardEventOccurred, (void*)taraxl3d );

   	g_PclViewer->runOnVisualizationThreadOnce (viewerOneOff);
   	g_PclViewer->runOnVisualizationThread (viewerUpdate);

   	while(!g_PclViewer->wasStopped())
   	{

		#ifdef PRINT_TIME
     		gettimeofday(&start, 0);
    	#endif

    	io_mutex.lock();
    	status =  taraxl3d->getPoints(currentCloud);
    	io_mutex.unlock();
    

		#ifdef PRINT_TIME
     		gettimeofday(&end, 0);
     		deltatime = (float)(end.tv_sec - start.tv_sec + (end.tv_usec - start.tv_usec) * 1e-6);

     		fpsTotaltime += deltatime;
     		iFpsFrames++;
     		if (fpsTotaltime > 1.0f)
     		{
      			cout<<endl<<((float)iFpsFrames / fpsTotaltime) ;
      			fpsTotaltime = 0.0f;
      			iFpsFrames = 0;
     		}
		#endif

    	g_PclViewer->showCloud(currentCloud);

	}
	delete taraxl3d;
   	exit(0);
}
