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
    ui->mainToolBar->addWidget(label1);
    setupGraphs(ui->customPlot,ui->customPlot2,ui->customPlot3);
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
      legendTitle->setLayer(customPlot->legend->layer()); // place text element on same layer as legend, or it ends up below legend
      legendTitle->setText("Linear Acceleration(mg)               ");
      legendTitle->setFont(QFont("sans", 9, QFont::Bold));
      if (customPlot->legend->hasElement(0, 0)) // if top cell isn't empty, insert an empty row at top
        customPlot->legend->insertRow(0);
      customPlot->legend->addElement(0, 0, legendTitle); // place the text element into the empty cell




  ui->customPlot->plotLayout()->addElement(0, 1, subLayout);
  subLayout->addElement(1, 0, new QCPLayoutElement);
  subLayout->addElement(2, 0, ui->customPlot->legend);
  subLayout->addElement(3, 0, new QCPLayoutElement);

 //ui->customPlot->plotLayout()->setMaximumSize(20,5);
 ui->customPlot->plotLayout()->setColumnStretchFactor(1, 0.25);


       // QCPTextElement title(customPlot,"Linear Acceleration");

      customPlot->addGraph()->setName("x"); // blue line
      customPlot->graph(0)->setPen(QPen(QColor(255, 110, 40)));
      customPlot->addGraph()->setName("y"); // red line
      customPlot->graph(1)->setPen(QPen(QColor(40, 110, 255)));
      customPlot->addGraph()->setName("z"); // green line
      customPlot->graph(2)->setPen(QPen(QColor(40, 255, 110)));


      QCPTextElement *legendTitle2 = new QCPTextElement(customPlot2);
      legendTitle2->setLayer(customPlot2->legend->layer()); // place text element on same layer as legend, or it ends up below legend
      legendTitle2->setText("Angular Velocity(dps)                  ");
      legendTitle2->setFont(QFont("sans", 9, QFont::Bold));
      if (customPlot2->legend->hasElement(0, 0)) // if top cell isn't empty, insert an empty row at top
        customPlot2->legend->insertRow(0);
      customPlot2->legend->addElement(0, 0, legendTitle2); // place the text element into the empty cell

  ui->customPlot2->plotLayout()->addElement(0, 1, subLayout2);
  
  subLayout2->addElement(1, 0, new QCPLayoutElement);
  subLayout2->addElement(2, 0, ui->customPlot2->legend);
  subLayout2->addElement(3, 0, new QCPLayoutElement);
  ui->customPlot2->plotLayout()->setColumnStretchFactor(1, 0.25);

     customPlot2->legend->setVisible(true);
      customPlot2->addGraph()->setName("x"); // blue line
      customPlot2->graph(0)->setPen(QPen(QColor(255, 110, 40)));
      customPlot2->addGraph()->setName("y"); // red line
      customPlot2->graph(1)->setPen(QPen(QColor(40, 110, 255)));
      customPlot2->addGraph()->setName("z"); // green line
      customPlot2->graph(2)->setPen(QPen(QColor(40, 255, 110)));

      QCPTextElement *legendTitle3 = new QCPTextElement(customPlot3);
      legendTitle3->setLayer(customPlot3->legend->layer()); // place text element on same layer as legend, or it ends up below legend
      legendTitle3->setText("Inclination(degrees)                     ");
      legendTitle3->setFont(QFont("sans", 9, QFont::Bold));
      if (customPlot3->legend->hasElement(0, 0)) // if top cell isn't empty, insert an empty row at top
        customPlot3->legend->insertRow(0);
      customPlot3->legend->addElement(0, 0, legendTitle3); // place the text element into the empty cell

  ui->customPlot3->plotLayout()->addElement(0, 1, subLayout3);
  subLayout3->addElement(1, 0, new QCPLayoutElement);
  subLayout3->addElement(2, 0, ui->customPlot3->legend);
  subLayout3->addElement(3, 0, new QCPLayoutElement);
  ui->customPlot3->plotLayout()->setColumnStretchFactor(1, 0.25);


      customPlot3->legend->setVisible(true);
      customPlot3->addGraph()->setName("x"); // blue line
      customPlot3->graph(0)->setPen(QPen(QColor(255, 110, 40)));
      customPlot3->addGraph()->setName("y"); // red line
      customPlot3->graph(1)->setPen(QPen(QColor(40, 110, 255)));
      customPlot3->addGraph()->setName("z");; // green line
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


      // make left and bottom axes transfer their ranges to right and top axes:
      connect(customPlot->xAxis, SIGNAL(rangeChanged(QCPRange)), customPlot->xAxis2, SLOT(setRange(QCPRange)));
      connect(customPlot->yAxis, SIGNAL(rangeChanged(QCPRange)), customPlot->yAxis2, SLOT(setRange(QCPRange)));

      connect(customPlot2->xAxis, SIGNAL(rangeChanged(QCPRange)), customPlot2->xAxis2, SLOT(setRange(QCPRange)));
      connect(customPlot2->yAxis, SIGNAL(rangeChanged(QCPRange)), customPlot2->yAxis2, SLOT(setRange(QCPRange)));


      connect(customPlot3->xAxis, SIGNAL(rangeChanged(QCPRange)), customPlot3->xAxis2, SLOT(setRange(QCPRange)));
      connect(customPlot3->yAxis, SIGNAL(rangeChanged(QCPRange)), customPlot3->yAxis2, SLOT(setRange(QCPRange)));





      // setup a timer that repeatedly calls MainWindow::realtimeDataSlot:
      connect(&dataTimer, SIGNAL(timeout()), this, SLOT(realtimeDataSlot()));
      dataTimer.start(10); // Interval 0 means to refresh as fast as possible

}

void MainWindow::realtimeDataSlot()
{

if(k==1)
        return;
    static QTime time(QTime::currentTime());
    // calculate two new data points:
    double key = time.elapsed()/1000.0; // time elapsed since start of demo, in seconds
    static double lastPointKey = 0;

    
      // add data to lines:
        taraxlpose->getIMUData(imuData);
ui->customPlot->graph(0)->addData(key, imuData.linearAcceleration[0]);
ui->customPlot->graph(1)->addData(key, imuData.linearAcceleration[1]);
ui->customPlot->graph(2)->addData(key, imuData.linearAcceleration[2]);
      

ui->customPlot2->graph(0)->addData(key, imuData.angularVelocity[0]);
ui->customPlot2->graph(1)->addData(key, imuData.angularVelocity[1]);
ui->customPlot2->graph(2)->addData(key, imuData.angularVelocity[2]);

ui->customPlot3->graph(0)->addData(key, imuData.getInclination()[0]);
ui->customPlot3->graph(1)->addData(key, imuData.getInclination()[1]);
ui->customPlot3->graph(2)->addData(key, imuData.getInclination()[2]);


      i++;  if(i==10) i=0;

     
    
    // make key axis range scroll with the data (at a constant range size of 8):
   
 QCPTextElement* text = new QCPTextElement(ui->customPlot) ;
       QCPTextElement* text2 = new QCPTextElement(ui->customPlot2) ;
      QCPTextElement* text3 = new QCPTextElement(ui->customPlot3) ;

   QFont font; 
   font.setBold(true);
   text->setFont(font); 
   text2->setFont(font);
   text3->setFont(font);


    ui->customPlot->xAxis->setRange(key, 8, Qt::AlignRight);
    ui->customPlot->yAxis->rescale();
    ui->customPlot->replot();

   
    

    ui->customPlot2->xAxis->setRange(key, 8, Qt::AlignRight);
    ui->customPlot2->yAxis->rescale();
    ui->customPlot2->replot();

    
    

    ui->customPlot3->xAxis->setRange(key, 8, Qt::AlignRight);
    ui->customPlot3->yAxis->rescale();
    ui->customPlot3->replot();


if ( key - lastPointKey > 0.5)
{
    
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

lastPointKey = key;
}


label1->setText(QString("TaraXL Sample IMU Application"));


}

void MainWindow::on_actionPlay_triggered()
{
    k=0;
    ui->actionPlay->setEnabled(false);
    ui->actionPause->setEnabled(true);

}

void MainWindow::on_actionPause_triggered()
{
    k=1;
    ui->actionPlay->setEnabled(true);
    ui->actionPause->setEnabled(false);

}

