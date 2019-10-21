#include "mainwindow.h"
#include "ui_mainwindow.h"

#include<iostream>
using namespace std;

using namespace TaraXLSDK;



MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    this->setWindowTitle("TaraXL IMU APP");
    ui->actionPlay->setEnabled(false);
    ui->mainToolBar->addWidget(heading);
    setupGraphs(ui->customPlot,ui->customPlot2,ui->customPlot3);
    escValue = true;
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::setupGraphs(QCustomPlot *customPlot,QCustomPlot *customPlot2,QCustomPlot *customPlot3)
{

  status = taraxlCam.enumerateDevices(taraxlCamList);
  if (status != TARAXL_SUCCESS) 
     {
      std::cout << "No cameras connected" << endl; 
      exit(0) ;
     }

  selectedCam = taraxlCamList.at(0);
  status = selectedCam.connect();
  if (status != TARAXL_SUCCESS) 
     {
      std::cout << "Camera connect failed" << endl; 
      exit(0) ;
     }

   taraxlpose = new TaraXLPoseTracking(selectedCam);


  customPlot->legend->setVisible(true);


  QColor color(255,255,255);
  QPen pen;
  pen.setColor(color);
  customPlot->legend->setBorderPen(pen);
  customPlot2->legend->setBorderPen(pen);
  customPlot3->legend->setBorderPen(pen);


  QCPTextElement *legendTitle = new QCPTextElement(customPlot);
  legendTitle->setLayer(customPlot->legend->layer()); 
  legendTitle->setText("Linear Acceleration(mg)               ");
  legendTitle->setFont(QFont("sans", 9, QFont::Bold));
  if (customPlot->legend->hasElement(0, 0)) 
    customPlot->legend->insertRow(0);
   customPlot->legend->addElement(0, 0, legendTitle); 


  ui->customPlot->plotLayout()->addElement(0, 1, subLayout);
  subLayout->addElement(1, 0, new QCPLayoutElement);
  subLayout->addElement(2, 0, ui->customPlot->legend);
  subLayout->addElement(3, 0, new QCPLayoutElement);

 
  ui->customPlot->plotLayout()->setColumnStretchFactor(1, 0.25);

      
  customPlot->addGraph()->setName("x"); 
  customPlot->graph(0)->setPen(QPen(QColor(255, 110, 40)));
  customPlot->addGraph()->setName("y"); 
  customPlot->graph(1)->setPen(QPen(QColor(40, 110, 255)));
  customPlot->addGraph()->setName("z"); 
  customPlot->graph(2)->setPen(QPen(QColor(40, 255, 110)));


  QCPTextElement *legendTitle2 = new QCPTextElement(customPlot2);
  legendTitle2->setLayer(customPlot2->legend->layer()); 
  legendTitle2->setText("Angular Velocity(dps)                  ");
  legendTitle2->setFont(QFont("sans", 9, QFont::Bold));
  if (customPlot2->legend->hasElement(0, 0)) 
   customPlot2->legend->insertRow(0);
  customPlot2->legend->addElement(0, 0, legendTitle2); 

  ui->customPlot2->plotLayout()->addElement(0, 1, subLayout2);
  
  subLayout2->addElement(1, 0, new QCPLayoutElement);
  subLayout2->addElement(2, 0, ui->customPlot2->legend);
  subLayout2->addElement(3, 0, new QCPLayoutElement);
  ui->customPlot2->plotLayout()->setColumnStretchFactor(1, 0.25);

  customPlot2->legend->setVisible(true);
  customPlot2->addGraph()->setName("x"); 
  customPlot2->graph(0)->setPen(QPen(QColor(255, 110, 40)));
  customPlot2->addGraph()->setName("y"); 
  customPlot2->graph(1)->setPen(QPen(QColor(40, 110, 255)));
  customPlot2->addGraph()->setName("z"); 
  customPlot2->graph(2)->setPen(QPen(QColor(40, 255, 110)));

  QCPTextElement *legendTitle3 = new QCPTextElement(customPlot3);
  legendTitle3->setLayer(customPlot3->legend->layer()); 
  legendTitle3->setText("Inclination(degrees)                     ");
  legendTitle3->setFont(QFont("sans", 9, QFont::Bold));
  if (customPlot3->legend->hasElement(0, 0)) 
   customPlot3->legend->insertRow(0);
  customPlot3->legend->addElement(0, 0, legendTitle3); 

  ui->customPlot3->plotLayout()->addElement(0, 1, subLayout3);
  subLayout3->addElement(1, 0, new QCPLayoutElement);
  subLayout3->addElement(2, 0, ui->customPlot3->legend);
  subLayout3->addElement(3, 0, new QCPLayoutElement);
  ui->customPlot3->plotLayout()->setColumnStretchFactor(1, 0.25);


  customPlot3->legend->setVisible(true);
  customPlot3->addGraph()->setName("x"); 
  customPlot3->graph(0)->setPen(QPen(QColor(255, 110, 40)));
  customPlot3->addGraph()->setName("y"); 
  customPlot3->graph(1)->setPen(QPen(QColor(40, 110, 255)));
  customPlot3->addGraph()->setName("z");; 
  customPlot3->graph(2)->setPen(QPen(QColor(40, 255, 110)));


  QSharedPointer<QCPAxisTickerTime> timeTicker(new QCPAxisTickerTime);
  timeTicker->setTimeFormat("%m:%s");
  timeTicker->setTickStepStrategy(QCPAxisTicker::tssMeetTickCount);
  timeTicker->setTickCount(5);
  customPlot->xAxis->setTicker(timeTicker);
  customPlot->axisRect()->setupFullAxesBox();


  customPlot2->xAxis->setTicker(timeTicker);
  customPlot2->axisRect()->setupFullAxesBox();
  

  customPlot3->xAxis->setTicker(timeTicker);
  customPlot3->axisRect()->setupFullAxesBox();

  connect(customPlot->xAxis, SIGNAL(rangeChanged(QCPRange)), customPlot->xAxis2, SLOT(setRange(QCPRange)));
  connect(customPlot->yAxis, SIGNAL(rangeChanged(QCPRange)), customPlot->yAxis2, SLOT(setRange(QCPRange)));

  connect(customPlot2->xAxis, SIGNAL(rangeChanged(QCPRange)), customPlot2->xAxis2, SLOT(setRange(QCPRange)));
  connect(customPlot2->yAxis, SIGNAL(rangeChanged(QCPRange)), customPlot2->yAxis2, SLOT(setRange(QCPRange)));

  connect(customPlot3->xAxis, SIGNAL(rangeChanged(QCPRange)), customPlot3->xAxis2, SLOT(setRange(QCPRange)));
  connect(customPlot3->yAxis, SIGNAL(rangeChanged(QCPRange)), customPlot3->yAxis2, SLOT(setRange(QCPRange)));


  connect(&dataTimer, SIGNAL(timeout()), this, SLOT(realtimeDataSlot()));
  dataTimer.start(10); 
}

void MainWindow::realtimeDataSlot()
{

   if(isPaussed==1)
        return;
    static QTime time(QTime::currentTime());
    static QTime time2(QTime::currentTime());
    
    double key = time.elapsed()/1000.0; 
    double key2 = time2.elapsed()/1000.0; 
   
    Vector3 imu;
    
    taraxlpose->getIMUData(imuData);
   
    ui->customPlot->graph(0)->addData(key, imuData.linearAcceleration[0]); //x-value   
    ui->customPlot->graph(1)->addData(key, imuData.linearAcceleration[1]); //y-value
    ui->customPlot->graph(2)->addData(key, imuData.linearAcceleration[2]); //z-value

    ui->customPlot->xAxis->setRange(key, 8,Qt::AlignRight);
    ui->customPlot->yAxis->rescale();
    ui->customPlot->replot(QCustomPlot::rpImmediateRefresh);

      
    ui->customPlot2->graph(0)->addData(key, imuData.angularVelocity[0]); //x-value
    ui->customPlot2->graph(1)->addData(key, imuData.angularVelocity[1]); //y-value
    ui->customPlot2->graph(2)->addData(key, imuData.angularVelocity[2]); //z-value

    ui->customPlot2->xAxis->setRange(key, 8, Qt::AlignRight);
    ui->customPlot2->yAxis->rescale();
    ui->customPlot2->replot(QCustomPlot::rpImmediateRefresh);


    imu = imuData.getInclination();
    ui->customPlot3->graph(0)->addData(key, imu[0]); //x-value
    ui->customPlot3->graph(1)->addData(key, imu[1]); //y-value
    ui->customPlot3->graph(2)->addData(key, imu[2]); //z-value
    
    ui->customPlot3->xAxis->setRange(key, 8, Qt::AlignRight);
    ui->customPlot3->yAxis->rescale();
    ui->customPlot3->replot(QCustomPlot::rpImmediateRefresh);

    if ( key2 > 1)
    {

     QCPTextElement* text = new QCPTextElement(ui->customPlot) ;
     QCPTextElement* text2 = new QCPTextElement(ui->customPlot2) ;
     QCPTextElement* text3 = new QCPTextElement(ui->customPlot3) ;


     QFont font; 
     font.setBold(true);
     text->setFont(font); 
     text2->setFont(font);
     text3->setFont(font);

     subLayout->removeAt(1); 
     text->setText(QString("x: %1 , y: %2 , z: %3  ")
                    .arg(imuData.linearAcceleration[0],7,'f',2)
                    .arg(imuData.linearAcceleration[1],7,'f',2)
		    .arg(imuData.linearAcceleration[2],7,'f',2));
     subLayout->addElement(1,0,text);
     subLayout->updateLayout();


     subLayout2->removeAt(1); 
     text2->setText(QString("x: %1 , y: %2 , z: %3   ")
                  .arg(imuData.angularVelocity[0],7,'f',2)
                  .arg(imuData.angularVelocity[1],7,'f',2)
                  .arg(imuData.angularVelocity[2],7,'f',2));
     subLayout2->addElement(1,0,text2);
     subLayout2->updateLayout();


     subLayout3->removeAt(1); 
     text3->setText(QString("x: %1 , y: %2 , z: %3   ")
                  .arg(imuData.getInclination()[0],7,'f',2)
                  .arg(imuData.getInclination()[1],7,'f',2)
		  .arg(imuData.getInclination()[2],7,'f',2));
     subLayout3->addElement(1,0,text3);
     subLayout3->updateLayout();

     time2.restart();
     escValue = true;
    }


//Graph will re-set after 20 hours. So the overlapping of old data with new data will be avoided.
if((((int)key % 72000) < 1.0) && escValue)
{
time.restart();

QVector<double> vectorKey;
QVector<double> imuValues;

ui->customPlot->graph(0)->setData(vectorKey, imuValues); 
ui->customPlot->graph(1)->setData(vectorKey, imuValues); 
ui->customPlot->graph(2)->setData(vectorKey, imuValues); 

ui->customPlot2->graph(0)->setData(vectorKey, imuValues); 
ui->customPlot2->graph(1)->setData(vectorKey, imuValues); 
ui->customPlot2->graph(2)->setData(vectorKey, imuValues); 

ui->customPlot3->graph(0)->setData(vectorKey, imuValues); 
ui->customPlot3->graph(1)->setData(vectorKey, imuValues); 
ui->customPlot3->graph(2)->setData(vectorKey, imuValues); 

escValue = false;
}
                  
heading->setText(QString("TaraXL Sample IMU Application"));


}

void MainWindow::on_actionPlay_triggered()
{
    isPaussed=0;
    ui->actionPlay->setEnabled(false);
    ui->actionPause->setEnabled(true);

}

void MainWindow::on_actionPause_triggered()
{
    isPaussed=1;
    ui->actionPlay->setEnabled(true);
    ui->actionPause->setEnabled(false);

}

