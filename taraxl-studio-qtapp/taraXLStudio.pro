QT += quick
CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    main.cpp \
    imageprovider.cpp \
    camera.cpp

RESOURCES += qml.qrc

OBJECTS_DIR=./build
MOC_DIR=./build

QMAKE_CXXFLAGS += `pkg-config --cflags glib-2.0`

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    imageprovider.h \
    camera.h

INCLUDEPATH += \
	"/usr/local/taraxl-sdk/include" \
	"/usr/local/taraxl-opencv/include" \

LIBS += \
	-L"/usr/local/taraxl-sdk/lib/" -lecon_taraxl \
	-L"/usr/local/taraxl-opencv/lib" -lopencv_core -lopencv_imgproc -lopencv_imgcodecs\ 
	-L"/usr/lib/aarch64-linux-gnu/tegra/" -lGL
