#ifndef CAMERA_H
#define CAMERA_H

#include <sys/time.h>
#include <signal.h>

#include <QPainter>
#include <QStringListModel>

#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

#include "TaraXL.h"
#include "TaraXLCam.h"
#include "TaraXLDepth.h"

#include "imageprovider.h"

class camera : public QObject {

    Q_OBJECT

    Q_PROPERTY(cv::Mat leftImage READ getLeftImage WRITE setLeftImage NOTIFY leftImageChanged)
    Q_PROPERTY(cv::Mat rightImage READ getRightImage WRITE setRightImage NOTIFY rightImageChanged)
    Q_PROPERTY(cv::Mat disp0Image READ getDisp0Image WRITE setDisp0Image NOTIFY disp0ImageChanged)
    Q_PROPERTY(cv::Mat disp1Image READ getDisp1Image WRITE setDisp1Image NOTIFY disp1ImageChanged)

    Q_PROPERTY(QStringList camList READ getCamList WRITE setCamList NOTIFY camListChanged)

    Q_PROPERTY(QStringList resolutionList READ getResList WRITE setResList NOTIFY resListChanged)

    Q_PROPERTY(QString fps READ getFps WRITE setFps NOTIFY fpsUpdated)
    Q_PROPERTY(QString depth READ getDepth WRITE setDepth NOTIFY depthUpdated)

    Q_PROPERTY(bool camConnected READ isCamConnected WRITE setCamConnected NOTIFY cameraConnected)

public:
    camera();

    ~camera();

public Q_SLOTS:
    void getConnectedCameras();

    void getSupportedResolutions();

    void connectCamera(const int index);

    void startPreview();

    void setResolution(const int index);

    int getBrightnessVal();

    void setBrightnessVal(const int value);

    int getExposureVal();

    void setExposureVal(const int value);

    void enableAutoExposure();

    void setAccuracyMode(const bool highAccuracy);

    void getDepth(const int X, const int Y, const int viewerWidth, const int viewerHeight);

private:
    TaraXLSDK::ACCURACY_MODE m_eAccuracy;

    int m_iNoOfCamerasConnected;

    bool m_bIsCameraConnected;

    ImageProvider *m_pImgProvider;

    QStringList m_camList;
    QStringList m_resList;

    int m_iSelectedCamIndex;
    int m_iSelectedResolutionIndex;

    QString m_fps;

    QString m_depth;

    TaraXLSDK::TaraXL m_tara;

    TaraXLSDK::TaraXLCam m_selectedCam;

    TaraXLSDK::TaraXLCamList m_taraCamList;

    TaraXLSDK::Resolution m_selectedRes;

    TaraXLSDK::ResolutionList m_supportedResolutions;

    TaraXLSDK::TaraXLDepth *m_taraDepth;

    bool m_bGetDepth;
    int m_iX;
    int m_iY;

    bool isCamConnected();
    void setCamConnected(bool camConnected);

    cv::Mat getLeftImage();
    void setLeftImage(const cv::Mat img);

    cv::Mat getRightImage();
    void setRightImage(const cv::Mat img);

    cv::Mat getDisp0Image();
    void setDisp0Image(const cv::Mat img);

    cv::Mat getDisp1Image();
    void setDisp1Image(const cv::Mat img);

    QStringList getCamList();
    void setCamList(const QStringList camList);

    QStringList getResList();
    void setResList(const QStringList resList);

    QString getFps();
    void setFps(const QString fps);

    QString getDepth();
    void setDepth(const QString depth);

    static void* previewThreadCreateHelper(void* arg);

    void previewThread();

    bool getMappedCoordinates(double iXPos, double iYPos, double *calX, double *calY, const int viewerWidth, const int viewerHeight);

signals:
    void cameraConnected();

    void leftImageChanged();

    void rightImageChanged();

    void disp0ImageChanged();

    void disp1ImageChanged();

    void camListChanged();

    void resListChanged();

    void fpsUpdated();

    void depthUpdated();
};

#endif // CAMERA_H
