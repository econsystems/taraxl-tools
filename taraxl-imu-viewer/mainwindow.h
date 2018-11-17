#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QTimer>
#include "qcustomplot.h"

#include "TaraXL.h"
#include "TaraXLCam.h"
#include "TaraXLDepth.h"
#include "TaraXLPoseTracking.h"
using namespace TaraXLSDK;

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = nullptr);
    ~MainWindow();
    void setupGraphs(QCustomPlot *customPlot,QCustomPlot *customPlot2,QCustomPlot *customPlot3);
     int i=0;

private slots:
  //void realtimeDataSlot(TaraXLSDK::TaraXLPoseTracking *taraxlpose,TaraXLSDK::TaraXLIMUData data);
  void realtimeDataSlot();
  void on_actionPlay_triggered();
 void on_actionPause_triggered();

private:
    Ui::MainWindow *ui;
    QTimer dataTimer;
    int k=0;
    QLabel* label1 = new QLabel;

TaraXL taraxlCam;
  TaraXLCam selectedCam;
  TaraXLCamList taraxlCamList;
  TaraXLDepth *taraxlDepth;
  TaraXLPoseTracking *taraxlpose; 
  TARAXL_STATUS_CODE status;
struct TaraXLIMUData imuData;

  
QCPLayoutGrid *subLayout = new QCPLayoutGrid;
       QCPLayoutGrid *subLayout2 = new QCPLayoutGrid;
        QCPLayoutGrid *subLayout3 = new QCPLayoutGrid;

};

#endif // MAINWINDOW_H
