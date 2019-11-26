#-------------------------------------------------
#
# Project created by QtCreator 2018-11-03T11:13:33
#
#-------------------------------------------------

QT       += core gui widgets

QT += widgets printsupport
QT +=widgets

TARGET = taraxlimu
TEMPLATE = app

# The following define makes your compiler emit warnings if you use
# any feature of Qt which has been marked as deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

CONFIG += c++11

QMAKE_CXXFLAGS += -std=c++0x

SOURCES += \
        main.cpp \
        mainwindow.cpp \
    qcustomplot.cpp

HEADERS += \
        mainwindow.h \
    qcustomplot.h

FORMS += \
        mainwindow.ui


# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

INCLUDEPATH += \
	"/usr/local/taraxl-sdk/include" \
	"/usr/local/taraxl-opencv/include" \

LIBS += \
	-L"/usr/local/taraxl-sdk/lib" -lecon_taraxl \
	-L"/usr/local/taraxl-opencv/lib" -lopencv_core -lopencv_imgproc \ 
	-L"/usr/lib/aarch64-linux-gnu/tegra/" -lGL \

RESOURCES += \
    images.qrc

