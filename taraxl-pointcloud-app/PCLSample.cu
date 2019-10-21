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
#include "pcl/common/transforms.h"

using namespace std;
using namespace cv;
using namespace TaraXLSDK;
using namespace pcl;


enum quality{STANDARD = 0, MEDIUM = 1, HIGHEST = 2 };
quality pcl_quality = quality::HIGHEST;
enum save{PLY = 0, PCD = 1, VTK = 2};
save pcl_save = PLY;
int showSaved=0,savePressed=0;

boost::mutex ioMutex;


void viewerOneOff (pcl::visualization::PCLVisualizer& viewer)
{

	viewer.setShowFPS(false);
    viewer.addText("Quality mode : Highest",20,80,15,10,10,255,"mode");
    viewer.addText("Press m/M to change quality",20,60,15,10,10,255,"modeInst");
    viewer.addText("Save format : PLY",20,40,15,10,10,255,"saveFormat");
    viewer.addText("Press n/N to change save format",20,20,15,10,10,255,"saveInst");
    viewer.addText("Press SHIFT+S to save",20,0,15,10,10,255,"saved");

}


void viewerUpdate (pcl::visualization::PCLVisualizer& viewer)
{

	if(pcl_quality==quality::STANDARD)
		viewer.updateText("Quality mode : Standard",20,80,15,10,10,255,"mode");
    if(pcl_quality==quality::MEDIUM)
        viewer.updateText("Quality mode : Medium",20,80,15,10,10,255,"mode");
    if(pcl_quality==quality::HIGHEST)
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
		viewer.updateText("Press SHIFT+S to save",20,0,15,10,10,255,"saved");  
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
    		case quality::HIGHEST:
     		status = taraxl3d->setPointcloudQuality(TaraXLSDK::STANDARD);
     		if (status != TARAXL_SUCCESS)
     		{
      			cout << "Quality set failed" << endl;
      			break ;
     		}
     		pcl_quality = quality::STANDARD;
     		break;

     		case quality::MEDIUM:
     		status = taraxl3d->setPointcloudQuality(TaraXLSDK::HIGHEST);
     		if (status != TARAXL_SUCCESS)
     		{
      			cout << "Quality set failed" << endl;
     			 break ;
     		}
    		pcl_quality = quality::HIGHEST;
    		break;

     		case quality::STANDARD:
     		status = taraxl3d->setPointcloudQuality(TaraXLSDK::MEDIUM);
     		if (status != TARAXL_SUCCESS)
    		{
      			cout << "Quality set failed" << endl;
      			break ;
     		}
     		pcl_quality = quality::MEDIUM;
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
		ioMutex.lock();

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

		 ioMutex.unlock();

	}

}


int main () 
{

	TaraXL taraxlCam;
  	TaraXLCam selectedCam;
 	TaraXLCamList taraxlCamList;
	ResolutionList supportedResolutions;
	TaraXLPointcloud *taraxl3d;
	pcl::visualization::CloudViewer *pclViewer;


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

  	status =selectedCam.setResolution(supportedResolutions.at(iResIndex));
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

  	pclViewer = new pcl::visualization::CloudViewer("TaraXL Point Cloud  Viewer");

	Points::Ptr currentCloud (new Points);	

   	pclViewer->registerKeyboardCallback (keyboardEventOccurred, (void*)taraxl3d );

   	pclViewer->runOnVisualizationThreadOnce (viewerOneOff);
   	pclViewer->runOnVisualizationThread (viewerUpdate);
	bool init = true;

	Eigen::Affine3f Transform_Matrix = Eigen::Affine3f::Identity();

        float Trans_x = 0.0;
        float Trans_y = 0.0;
        float Trans_z = 0.0 ; //15.0;
        float Rot_x = 0.0;
        float Rot_y = 0.0;
        float Rot_z = 0.0;

        // Define a translation of 2.5 meters on the x axis.
        Transform_Matrix.translation() << Trans_x, Trans_y, Trans_z;

        // The same rotation matrix as before; tetha radians arround Z axis
        Transform_Matrix.rotate (Eigen::AngleAxisf (Rot_x, Eigen::Vector3f::UnitX()));
        Transform_Matrix.rotate (Eigen::AngleAxisf (Rot_y, Eigen::Vector3f::UnitY()));
        Transform_Matrix.rotate (Eigen::AngleAxisf (Rot_z, Eigen::Vector3f::UnitZ()));

        PointCloud<PointXYZRGB>::Ptr point_cloud_Transformed_ptr (new PointCloud<PointXYZRGB>);


   	while(!pclViewer->wasStopped())
   	{
	
    	ioMutex.lock();
    	status =  taraxl3d->getPoints(currentCloud);
	
		if (status != TARAXL_SUCCESS) 
		{
			cout << "Get points failed" << endl;
      		return 1;
  		}
	
    	ioMutex.unlock();

	transformPointCloud (*currentCloud, *point_cloud_Transformed_ptr, Transform_Matrix);
        pclViewer->showCloud(point_cloud_Transformed_ptr);

	}

	delete taraxl3d;
	selectedCam.disconnect();
   	exit(0);
}
