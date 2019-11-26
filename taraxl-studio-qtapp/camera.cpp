#include "camera.h"
#include <cmath>
#include<thread>

using namespace std;
using namespace cv;
using namespace TaraXLSDK;

pthread_t m_gPreviewThread;
pthread_mutex_t g_mtx = PTHREAD_RECURSIVE_MUTEX_INITIALIZER_NP;
pthread_mutex_t g_mtx_depth = PTHREAD_RECURSIVE_MUTEX_INITIALIZER_NP;
std::thread lut1,lut2,lut3;
bool initializedFlag;
camera::camera() {

  m_pImgProvider = ImageProvider::getInstance();
  m_bGetDepth = false;
  m_bIsCameraConnected = false;
  initializedFlag = true;
}

camera::~camera() {

  pthread_cancel(m_gPreviewThread);
  m_selectedCam.disconnect();
  if(lut1.joinable())
  lut1.join();
  if(lut2.joinable())
  lut2.join();
  if(lut3.joinable())
  lut3.join();



  if (m_taraDepth != NULL) {

    delete m_taraDepth;
  }
}

bool camera::isCamConnected() {

  return m_bIsCameraConnected;
}

void camera::setCamConnected(bool camConnected) {

  m_bIsCameraConnected = camConnected;
  emit cameraConnected();
}

Mat camera::getLeftImage() {

  //    return m_pImgProvider->m_left;
  return cv::Mat(m_pImgProvider->img_left.height(), m_pImgProvider->img_left.width(),CV_8UC1, m_pImgProvider->img_left.bits(), m_pImgProvider->img_left.bytesPerLine());
}

void camera::setLeftImage(const Mat img) {

  QImage img1 = QImage((uchar *) img.data,img.cols,img.rows,img.step,QImage::Format_Indexed8);
  m_pImgProvider->img_left = img1;
  emit leftImageChanged();
}

Mat camera::getRightImage() {

  //    return m_pImgProvider->m_right;
  return cv::Mat(m_pImgProvider->img_right.height(), m_pImgProvider->img_right.width(),CV_8UC1, m_pImgProvider->img_right.bits(), m_pImgProvider->img_left.bytesPerLine());

}

void camera::setRightImage(const Mat img) {

  QImage img1 = QImage((uchar *) img.data,img.cols,img.rows,img.step,QImage::Format_Indexed8);
  m_pImgProvider->img_right = img1;
  emit rightImageChanged();
}

Mat camera::getDisp0Image() {

  //    return m_pImgProvider->m_disp0;
  return cv::Mat(m_pImgProvider->img_disp0.height(), m_pImgProvider->img_disp0.width(),CV_8UC1, m_pImgProvider->img_disp0.bits(), m_pImgProvider->img_disp0.bytesPerLine());

}

void camera::setDisp0Image(const Mat img) {

  QImage img1 = QImage((uchar *) img.data,img.cols,img.rows,img.step,QImage::Format_Indexed8);
  m_pImgProvider->img_disp0 = img1;
  emit disp0ImageChanged();
}

Mat camera::getDisp1Image() {

  //    return m_pImgProvider->m_disp1;
  cv::Mat colorDisp1 = Mat(m_pImgProvider->img_disp1.height(), m_pImgProvider->img_disp1.width(),CV_8UC3, m_pImgProvider->img_disp1.bits(), m_pImgProvider->img_disp1.bytesPerLine());
  cv::Mat colorDisp;
  colorDisp = colorDisp1.clone();
  cv::cvtColor(colorDisp, colorDisp, CV_RGB2BGR);
  return colorDisp;
}

void camera::setDisp1Image(const Mat img) {

  QImage img1 = QImage((uchar *) img.data,img.cols,img.rows,img.step,QImage::Format_RGB888);
  m_pImgProvider->img_disp1 = img1;
  emit disp1ImageChanged();
}

QStringList camera::getCamList() {

  return m_camList;
}

void camera::setCamList(const QStringList camList) {

  m_camList = camList;
  emit camListChanged();
}

QStringList camera::getResList() {

  return m_resList;
}

void camera::setResList(const QStringList resList) {

  m_resList = resList;
  emit resListChanged();
}

QString camera::getFps() {

  return m_fps;
}

void camera::setFps(const QString fps) {

  m_fps = fps;
  emit fpsUpdated();
}

QString camera::getDepth() {

  return m_depth;
}

void camera::setDepth(const QString depth) {

  m_depth = depth;
  emit depthUpdated();
}

void camera::getConnectedCameras() {

  QStringList devNames;
  m_tara.enumerateDevices(m_taraCamList);
  for (TaraXLCam cam: m_taraCamList) {

    string name;
    if (cam.getFriendlyName(name) == TARAXL_SUCCESS) {

      devNames.append(QString::fromStdString(name));
    }
  }

  m_iNoOfCamerasConnected = static_cast<int>(m_taraCamList.size());
  if (m_iNoOfCamerasConnected == 0) {

    devNames.clear();
    devNames.append("No camera connected");
  }
  setCamList(devNames);
}

void camera::connectCamera(const int index) {
  pthread_mutex_lock(&g_mtx_depth);
  TARAXL_STATUS_CODE status;
  if(m_bIsCameraConnected)
  {
    status = m_selectedCam.disconnect();
    if (status == TARAXL_SUCCESS) {

      cout << "disconnect success" << endl;
      setCamConnected(false);
    }
  }
  if (m_iNoOfCamerasConnected == 0) {

    return;
  }

  m_iSelectedCamIndex = index;
  m_selectedCam = m_taraCamList.at(m_iSelectedCamIndex);

  status = m_selectedCam.connect();
  if (status == TARAXL_SUCCESS) {

    cout << "Camera connect success" << endl;
    m_taraDepth = new TaraXLDepth(m_selectedCam);
    setCamConnected(true);
    m_iSelectedResolutionIndex = 0;
    m_selectedRes = m_supportedResolutions.at(m_iSelectedResolutionIndex);
  }
  else {

    cout << "Camera connect failed" << endl;
    setCamConnected(false);
  }
  initializedFlag = false;
  pthread_mutex_unlock(&g_mtx_depth);
}

void camera::getSupportedResolutions() {

  if (m_iNoOfCamerasConnected == 0) {

    return;
  }

  QStringList resolutionList;
  TARAXL_STATUS_CODE status = m_selectedCam.getResolutionList(m_supportedResolutions);
  if (status == TARAXL_SUCCESS) {

    for (Resolution res: m_supportedResolutions) {

      QString resolution;
      resolution.append(QString::number(res.width));
      resolution.append(" x ");
      resolution.append(QString::number(res.height));

      resolutionList.append(resolution);
    }
    setResList(resolutionList);
  }
  else {

    cout << "getSupportedResolution failed: " << status << endl;
  }
}

int camera::getCameraName()
{

  std::string name;
  TARAXL_STATUS_CODE status = m_selectedCam.getFriendlyName(name);

  if (name == "See3CAM_StereoA")
  return 1;

  else
  return 2;

}
void camera::startPreview() {
  if (!m_bIsCameraConnected) {

    return;
  }
  if (!pthread_create(&m_gPreviewThread, NULL, camera::previewThreadCreateHelper, this)) {
    if (pthread_detach(m_gPreviewThread) != 0) {
      exit(EXIT_FAILURE);
    }
  }
}
void camera::saveImages(){
  imwrite("left_image.jpg", getLeftImage());
  imwrite("right_image.jpg", getRightImage());
  imwrite("grey_map.jpg", getDisp0Image());
  imwrite("color_map.jpg", getDisp1Image());
  cout << "Images saved successfully! " << endl;
}

// static method for pthread to invoke the actual method
void* camera::previewThreadCreateHelper(void* arg) {

  camera* dis = reinterpret_cast<camera*>(arg);
  dis->previewThread();
  return NULL;
}

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

void camera::previewThread() {

  Mat left, right, disp0, disp1, depthMap;

  timeval totalStart, totalEnd;
  float fpsDeltatime, fpsTotaltime,fps;
  unsigned int iFpsFrames = 0;


  Mat cdr, cdg, cdb;
  //COLORMAP JET LUT




  while (1) {


  int minDisp,maxDisp;
  m_taraDepth->getMinDisparity(minDisp);
  m_taraDepth->getMaxDisparity(maxDisp);



  uchar r[] = {128,136,144,152,160,168,176,184,192,200,208,216,224,232,240,248,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,254,246,238,230,222,214,206,198,190,182,174,166,158,150,142,134,126,118,110,102,94,86,78,70,62,54,46,38,30,22,14,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

  uchar g[] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,16,24,32,40,48,56,64,72,80,88,96,104,112,120,128,136,144,152,160,168,176,184,192,200,208,216,224,232,240,248,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,252,244,236,228,220,212,204,196,188,180,172,164,156,148,140,132,124,116,108,100,92,84,76,68,60,52,44,36,28,20,12,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

 uchar b[] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,10,18,26,34,42,50,58,66,74,82,90,98,106,114,122,130,138,146,154,162,170,178,186,194,202,210,218,226,234,242,250,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,252,244,236,228,220,212,204,196,188,180,172,164,156,148,140,132};


  uchar r1[256],g1[256],b1[256]; 

  for(int i = 0; i < 256 ; i++)
  {
	if(m_eAccuracy == HIGH)
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

    gettimeofday(&totalStart, 0);
    if (m_taraDepth != NULL) {
        pthread_mutex_lock(&g_mtx_depth);

      m_taraDepth->getMap(left, right, disp0, true, depthMap, false, TARAXL_DEFAULT_FILTER);
        pthread_mutex_unlock(&g_mtx_depth);
    }
    pthread_mutex_lock(&g_mtx);
    if (m_bGetDepth) {

      m_bGetDepth = false;
      cv::Mat_<float> vec(4, 1);
      cv::Mat Q,Q_32;
      TARAXL_STATUS_CODE status;
      status = m_selectedCam.getQMatrix(Q);

      int radiusX = 5;
      int radiusY = 5;
      cv::Point Pt = Point(m_iX, m_iY);
      cv::Point WithinImage(-1, -1);
      // cout << "Map : "  << endl;
      //Handling points in the corner

      //Handling points in the corner
      if((Pt.x + radiusX) > disp0.cols)
      {
        WithinImage.x = ( disp0.cols - (Pt.x + radiusX)) + Pt.x;
        WithinImage.y = Pt.y;
      }

      if((Pt.y + radiusY) > disp0.rows)
      {
        WithinImage.y = ( disp0.rows - (Pt.y + radiusY)) + Pt.y;
        if(WithinImage.x == -1) //In case x is within the range
        WithinImage.x = Pt.x;
      }

      if(WithinImage.x == -1 || WithinImage.y == -1)
      {
        WithinImage.x = Pt.x-(radiusX/2);
        WithinImage.y = Pt.y-(radiusY/2);
      }
      // cout << "Map : "  << endl;
      //Average depth of 20x20 around the selected point is taken
      cv::Rect recROI(WithinImage.x, WithinImage.y, radiusX, radiusY);

      // cout << "Map : "  << WithinImage.x << " " << WithinImage.y << endl;
      cv::Mat depthCrop;//(20,20,CV_32F);
      depthCrop = disp0(recROI);

      cv:Scalar tempVal = mean( depthCrop );

      Q.convertTo(Q_32, CV_32FC1);
      vec(0) = 0;
      vec(1) = 0;
      vec(2) = (float)tempVal.val[0];

      //cout << "Map : " << depthCrop << endl;
      //cout << "*********************************************" << myMAtMean <<endl;
      //cout << depthMap.at<float>(Point(m_iX, m_iY)) << endl;

      float depthValueInM;
      // Discard points with 0 disparity
      //	    if(vec(2) != 0)
      {
        vec(3) = 1.0;
        vec = Q_32 * vec;
        vec /= vec(3);
        // Discard points that are too far from the camera, and thus are highly unreliable
        depthValueInM = vec(2);
      }

      if (  isinf(depthValueInM) )
      setDepth(QString(" %1 ").arg(QString::number(depthValueInM, 'f', 2)));
      else
      setDepth(QString(" %1 m ").arg(QString::number(depthValueInM, 'f', 2)));
	
    }
    pthread_mutex_unlock(&g_mtx);
    setLeftImage(left);
    setRightImage(right);
    disp0.convertTo(disp0, CV_8UC1);

    if(lut3.joinable())
    lut3.join();
    if(lut2.joinable())
    lut2.join();
    if(lut1.joinable())
    lut1.join();

    lut3 = std::thread(lutB, disp0,lookUpTable_B, std::ref(cdb));
    lut1 = std::thread(lutR, disp0,lookUpTable_R,std::ref(cdr));
    lut2 = std::thread(lutG, disp0,lookUpTable_G,std::ref( cdg));
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
    cv::merge(planes,disp1);
    if (resChanged!=0 )
    {
      if( resChanged == 3)
      resChanged = 0;
      else
      resChanged++;
    }

    else if (resChanged==0)
    {
      setDisp0Image(disp0);
      setDisp1Image(disp1);
    }
    gettimeofday(&totalEnd, 0);
    fpsDeltatime = (float)(totalEnd.tv_sec - totalStart.tv_sec + (totalEnd.tv_usec - totalStart.tv_usec) * 1e-6);
    fpsTotaltime += fpsDeltatime;
    iFpsFrames++;

    if (fpsTotaltime > 1.0f) {
      fps = (float)iFpsFrames / fpsTotaltime ;
      fps = floor(fps + 0.5);

      setFps(QString(" %1 Hz").arg(QString::number(fps, 'f',0)));
      // setFps(QString::number(fps, 'f',0));
      fpsTotaltime = 0.0f;
      iFpsFrames = 0;

    }
  }
}


void camera::setResolution(int index) {
  pthread_mutex_lock(&g_mtx_depth);
  resChanged = 1;

  if (!m_bIsCameraConnected) {

    return;
  }

  TARAXL_STATUS_CODE status;

  if (m_supportedResolutions.size() > 0) {

    m_iSelectedResolutionIndex = index;
    m_selectedRes = m_supportedResolutions.at(m_iSelectedResolutionIndex);
    status = m_selectedCam.setResolution(m_selectedRes);
    if (status == TARAXL_SUCCESS) {

      cout << "setResolution success" << endl;
    }
  }
  pthread_mutex_unlock(&g_mtx_depth);
}

int camera::getBrightnessVal() {

  if (!m_bIsCameraConnected) {

    return -1;
  }

  int iBrightnessVal = -1;
  TARAXL_STATUS_CODE status = m_selectedCam.getBrightness(iBrightnessVal);
  if (status == TARAXL_SUCCESS) {

    cout << "getBrightness success" << endl;
  }
  else {

    cout << "getBrightness failed: " << status << endl;
  }
  return iBrightnessVal;
}

void camera::setBrightnessVal(const int value) {

  if (!m_bIsCameraConnected) {

    return;
  }

  TARAXL_STATUS_CODE status = m_selectedCam.setBrightness(value);
  if(status == TARAXL_SUCCESS) {

    cout << "setBrightness success" << endl;
  }
  else {

    cout << "setBrightness failed: " << status << endl;
  }
}

int camera::getGainVal() {

  if (!m_bIsCameraConnected) {

    return -1;
  }

  int iGainVal = -1;
  TARAXL_STATUS_CODE status = m_selectedCam.getGain(iGainVal);
  if (status == TARAXL_SUCCESS) {

    cout << "getGain success" << endl;
  }
  else {

    cout << "getGain failed: " << status << endl;
  }
  return iGainVal;
}

void camera::setGainVal(const int value) {

  if (!m_bIsCameraConnected) {

    return;
  }

  TARAXL_STATUS_CODE status = m_selectedCam.setGain(value);
  if(status == TARAXL_SUCCESS) {

    cout << "setGain success" << endl;
  }
  else {

    cout << "setGain failed: " << status << endl;
  }
}


int camera::getExposureVal() {

  if (!m_bIsCameraConnected) {

    return -1;
  }

  int iExposureVal = -1;
  TARAXL_STATUS_CODE status = m_selectedCam.getExposure(iExposureVal);
  if (status == TARAXL_SUCCESS) {

    cout << "getExposure success" << endl;
  }
  else {

    cout << "getExposure failed: " << status << endl;
  }
  return iExposureVal;
}

void camera::setExposureVal(const int value) {

  if (!m_bIsCameraConnected) {

    return;
  }

  TARAXL_STATUS_CODE status = m_selectedCam.setExposure(value);
  if (status == TARAXL_SUCCESS) {

    cout << "setExposure success" << endl;
  }
  else {

    cout << "setExposure failed: " << status << endl;
  }
}

void camera::enableAutoExposure() {

  if (!m_bIsCameraConnected) {

    return;
  }

  TARAXL_STATUS_CODE status = m_selectedCam.enableAutoExposure();
  if (status == TARAXL_SUCCESS) {

    cout << "enableAutoExposure success" << endl;
  }
  else {

    cout << "enableAutoExposure failed: " << status << endl;
  }
}
void camera::setDepthRange(const int selectedDepthRange)
{
  if ((!m_bIsCameraConnected) || (m_taraDepth == NULL)) {
    return;
  }
  string name;
  m_selectedCam.getFriendlyName(name);
     pthread_mutex_lock(&g_mtx_depth);
  TARAXL_STATUS_CODE status;
  switch (selectedDepthRange) {
    case 0:
    status = m_taraDepth->setDepthRange(TARAXL_DEFAULT_RANGE);
    break;
    case 1:
    status = m_taraDepth->setDepthRange(TARAXL_NEAR_RANGE);
    break;
    case 2:
    status = m_taraDepth->setDepthRange(TARAXL_VERY_NEAR_RANGE);
    break;
    default:
    status = m_taraDepth->setDepthRange(TARAXL_DEFAULT_RANGE);
  }
    pthread_mutex_unlock(&g_mtx_depth);
  if (status == TARAXL_SUCCESS) {
    cout << "selectedDepthRange success" << endl;
    pthread_mutex_lock(&g_mtx);

    switch (selectedDepthRange) {
      case 0:
      m_eDepthRange = TARAXL_DEFAULT_RANGE;
      break;
      case 1:
      m_eDepthRange = TARAXL_NEAR_RANGE;
      break;
      case 2:
      m_eDepthRange = TARAXL_VERY_NEAR_RANGE;
      break;
      default:
      m_eDepthRange = TARAXL_DEFAULT_RANGE;
    }
    pthread_mutex_unlock(&g_mtx);
  }
  else {
    cout << "selectedDepthRange failed" << endl;
  }
}
void camera::setAccuracyMode(const int selectedAccuracyMode) {

  if ((!m_bIsCameraConnected) || (m_taraDepth == NULL)) {

    return;
  }
  string name;
  m_selectedCam.getFriendlyName(name);

     pthread_mutex_lock(&g_mtx_depth);
  TARAXL_STATUS_CODE status;
  switch (selectedAccuracyMode) {
    case 0:
    status = m_taraDepth->setAccuracy(HIGH);
    break;
    case 1:
    status = m_taraDepth->setAccuracy(LOW);
    break;
    case 2:
    status = m_taraDepth->setAccuracy(ULTRA);
    break;
    default:
    status = m_taraDepth->setAccuracy(HIGH);
  }
    pthread_mutex_unlock(&g_mtx_depth);
  if (status == TARAXL_SUCCESS) {

    cout << "set accuracy success" << endl;
    pthread_mutex_lock(&g_mtx);

    switch (selectedAccuracyMode) {
      case 0:
      m_eAccuracy = HIGH;
      break;
      case 1:
      m_eAccuracy = LOW;
      break;
      case 2:
      m_eAccuracy = ULTRA;
      break;
      default:
      m_eAccuracy = HIGH;
    }
    pthread_mutex_unlock(&g_mtx);
  }
  else {

    cout << "set accuracy failed" << endl;
  }
}

void camera::getDepth(int X, int Y, const int viewerWidth, const int viewerHeight) {

  double calculatedX, calculatedY;
  if (getMappedCoordinates((double)X, (double)Y, &calculatedX, &calculatedY, viewerWidth, viewerHeight)) {

    pthread_mutex_lock(&g_mtx);
    m_iX = (int)calculatedX;
    m_iY = (int)calculatedY;
    m_bGetDepth = true;
    pthread_mutex_unlock(&g_mtx);
  }
}

bool camera::getMappedCoordinates(double iXPos, double iYPos, double *calX, double *calY, const int viewerWidth, const int viewerHeight) {

  double dActualHeight, dActualWidth, dBlackRegionHeight, dBlackRegionWidth;
  dBlackRegionWidth = dBlackRegionHeight = 0;

  int connectedCamera, selectedWidth;
  connectedCamera = getCameraName();
  if (connectedCamera == 1)
  selectedWidth = m_selectedRes.width;
  else if (connectedCamera == 2)
  selectedWidth = (m_selectedRes.width/2);

  if( ((double)selectedWidth / (double)m_selectedRes.height) > ((double)viewerWidth / (double)viewerHeight) ) {

    dActualWidth = viewerWidth;
    dActualHeight = ((double)m_selectedRes.height / (double)selectedWidth) * viewerWidth;

    dBlackRegionWidth = 0;
    dBlackRegionHeight = viewerHeight - dActualHeight;

    if( (iXPos > 0) && (iXPos < dActualWidth) ) {

      if( (iYPos > (dBlackRegionHeight / 2)) && (iYPos < ((dBlackRegionHeight / 2) + dActualHeight)) ) {

        *calX = iXPos;
        *calY = iYPos - (dBlackRegionHeight / 2);
      }
      else {

        return false;
      }
    }
    else {

      return false;
    }
  }
  else if( ((double)selectedWidth / (double)m_selectedRes.height) < ((double)viewerWidth / (double)viewerHeight) ) {

    dActualWidth = ((double)selectedWidth / (double)m_selectedRes.height) * viewerHeight;
    dActualHeight = viewerHeight;

    dBlackRegionWidth = viewerWidth - dActualWidth;
    dBlackRegionHeight = 0;

    if( (iXPos > (dBlackRegionWidth / 2)) && (iXPos < ((dBlackRegionWidth / 2) + dActualWidth)) ) {

      if( (iYPos > 0) && (iYPos < dActualHeight) ) {

        *calX = iXPos - (dBlackRegionWidth / 2);
        *calY = iYPos;
      }
      else {

        return false;
      }
    }
    else {

      return false;
    }
  }
  else {

    *calX = iXPos;
    *calY = iYPos;
  }

  *calX = ((double)selectedWidth * (*calX)) / (viewerWidth - dBlackRegionWidth);
  *calY = ((double)m_selectedRes.height * (*calY)) / (viewerHeight - dBlackRegionHeight);

  return true;
}
