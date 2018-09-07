#include "camera.h"

using namespace std;
using namespace cv;
using namespace TaraXLSDK;

pthread_t m_gPreviewThread;
pthread_mutex_t g_mtx = PTHREAD_RECURSIVE_MUTEX_INITIALIZER_NP;

camera::camera() {

    m_pImgProvider = ImageProvider::getInstance();
}

camera::~camera() {

    pthread_cancel(m_gPreviewThread);
    m_selectedCam.disconnect();

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

    return m_pImgProvider->m_left;
}

void camera::setLeftImage(const Mat img) {

    m_pImgProvider->m_left = img.clone();
    emit leftImageChanged();
}

Mat camera::getRightImage() {

    return m_pImgProvider->m_right;
}

void camera::setRightImage(const Mat img) {

    m_pImgProvider->m_right = img.clone();
    emit rightImageChanged();
}

Mat camera::getDisp0Image() {

    return m_pImgProvider->m_disp0;
}

void camera::setDisp0Image(const Mat img) {

    m_pImgProvider->m_disp0 = img.clone();
    emit disp0ImageChanged();
}

Mat camera::getDisp1Image() {

    return m_pImgProvider->m_disp1;
}

void camera::setDisp1Image(const Mat img) {

    m_pImgProvider->m_disp1 = img.clone();
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

    pthread_cancel(m_gPreviewThread);
    TARAXL_STATUS_CODE status = m_selectedCam.disconnect();
    if (status == TARAXL_SUCCESS) {

        cout << "disconnect success" << endl;
        setCamConnected(false);
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

// static method for pthread to invoke the actual method
void* camera::previewThreadCreateHelper(void* arg) {

  camera* dis = reinterpret_cast<camera*>(arg);
  dis->previewThread();
  return NULL;
}

void camera::previewThread() {

    Mat left, right, disp0, disp1, depthMap;

    timeval totalStart, totalEnd;
    float fpsDeltatime, fpsTotaltime;
    unsigned int iFpsFrames = 0;

    while (1) {

        gettimeofday(&totalStart, 0);

        if (m_taraDepth != NULL) {

            m_taraDepth->getMap(left, right, disp0, true, depthMap, true);
        }

        pthread_mutex_lock(&g_mtx);
        if (m_eAccuracy == HIGH) {

            disp0 *= 2;
        }
        else {

            disp0 *= 4;
        }

        if (m_bGetDepth) {

            m_bGetDepth = false;
            float depthValueInCM = depthMap.at<float>(Point(m_iX, m_iY));
            setDepth(QString::number(depthValueInCM, 'f', 1));
        }
        pthread_mutex_unlock(&g_mtx);

        applyColorMap(disp0, disp1, COLORMAP_JET);
        setLeftImage(left);
        setRightImage(right);
        setDisp0Image(disp0);
        setDisp1Image(disp1);

        gettimeofday(&totalEnd, 0);
        fpsDeltatime = (float)(totalEnd.tv_sec - totalStart.tv_sec + (totalEnd.tv_usec - totalStart.tv_usec) * 1e-6);
        fpsTotaltime += fpsDeltatime;
        iFpsFrames++;

        if (fpsTotaltime > 1.0f) {

            setFps(QString::number((float)iFpsFrames / fpsTotaltime, 'f', 2));
            fpsTotaltime = 0.0f;
            iFpsFrames = 0;
        }
    }
}

void camera::setResolution(int index) {

    if (!m_bIsCameraConnected) {

        return;
    }

    pthread_cancel(m_gPreviewThread);
    TARAXL_STATUS_CODE status;

    if (m_supportedResolutions.size() > 0) {

        m_iSelectedResolutionIndex = index;
        m_selectedRes = m_supportedResolutions.at(m_iSelectedResolutionIndex);
        status = m_selectedCam.setResolution(m_selectedRes);
        if (status == TARAXL_SUCCESS) {

            cout << "setResolution success" << endl;
        }
    }

    startPreview();
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

void camera::setAccuracyMode(const bool bHighAccuracy) {

    if ((!m_bIsCameraConnected) || (m_taraDepth == NULL)) {

        return;
    }

    TARAXL_STATUS_CODE status;
    if (bHighAccuracy) {

        status = m_taraDepth->setAccuracy(HIGH);
    }
    else {

        status = m_taraDepth->setAccuracy(LOW);
    }

    if (status == TARAXL_SUCCESS) {

        cout << "set accuracy success" << endl;
        pthread_mutex_lock(&g_mtx);
        if (bHighAccuracy) {

            m_eAccuracy = HIGH;
        }
        else {

            m_eAccuracy = LOW;
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

    if( ((double)m_selectedRes.width / (double)m_selectedRes.height) > ((double)viewerWidth / (double)viewerHeight) ) {

        dActualWidth = viewerWidth;
        dActualHeight = ((double)m_selectedRes.height / (double)m_selectedRes.width) * viewerWidth;

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
    else if( ((double)m_selectedRes.width / (double)m_selectedRes.height) < ((double)viewerWidth / (double)viewerHeight) ) {

        dActualWidth = ((double)m_selectedRes.width / (double)m_selectedRes.height) * viewerHeight;
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

    *calX = ((double)m_selectedRes.width * (*calX)) / (viewerWidth - dBlackRegionWidth);
    *calY = ((double)m_selectedRes.height * (*calY)) / (viewerHeight - dBlackRegionHeight);

    return true;
}
