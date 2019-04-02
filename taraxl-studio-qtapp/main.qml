import QtQuick 2.5
import QtQuick.Window 2.2

import cam 1.0

Window {

    title: "TaraXL Studio"

    visible: true
//    visibility: Window.FullScreen
    flags: Qt.FramelessWindowHint //| Qt.Window
    width: Screen.width
    height: Screen.height
    property string frameId: "left"
    property var expVal: 0
    property var camName: ""
    property int camChanged: 0

Rectangle {
    id: mainWnd
    width: parent.width
    height: parent.height
    focus : true
    Keys.onPressed: {
        if (event.key == Qt.Key_S) {
            cam.saveImages()
        }
    }


    Camera {

        id: cam

        onCamListChanged: {

            cameraSelector.devListModel = camList
        }

        onCameraConnected: {

            if (camConnected) {

		camName = cam.getCameraName()
		if(camName == "1")
		{
			settings.gainSliderEnabled = false
                        settings.gainValTextEnabled = false
			settings.brightnessSliderEnabled = true
                        settings.brightnessValTextEnabled = true
			settings.exposureValMin = 10
			settings.exposureValMax = 1000000
                        settings.exposureVal = 8000
			settings.brightnessValMin = 1
                        settings.brightnessValMax = 7
                        settings.brightnessVal = 4			
		}
                else
		{
			settings.gainSliderEnabled = true
                        settings.gainValTextEnabled = true
			settings.brightnessSliderEnabled = false
			settings.brightnessValTextEnabled = false
			settings.exposureValMin = 1
			settings.exposureValMax = 7500
                        settings.exposureVal = 825
			settings.brightnessValMin =1 
                        settings.brightnessValMax = 10
		}

                settings.camCtrlRectEnabled = true
                settings.algoSettingsRectEnabled = true

                cam.getSupportedResolutions()
                settings.highAccuracyChecked = true

                cam.startPreview()

		settings.gainVal = 1
                expVal = cam.getExposureVal()

                cam.enableAutoExposure()
                settings.autoExposureChecked = true

		if(camName != "1")
			settings.brightnessVal = 6


                mainWnd.update()
            }
            else {

                settings.camCtrlRectEnabled = false
                settings.algoSettingsRectEnabled = false
            }
        }

        onResListChanged: {

            cameraSelector.resolutionModel = resolutionList
        }

        onLeftImageChanged: {

            if (previewGrid.visible) {

                leftFrame.cache = false
                leftFrame.source = ""
                leftFrame.source = "image://imageprovider/left"
                leftFrame.update()
            }
            else {

                if (frameId == "left") {

                    maximisedPreviewFrame.cache = false
                    maximisedPreviewFrame.source = ""
                    maximisedPreviewFrame.source = "image://imageprovider/left"
                    maximisedPreviewFrame.update()
                }
            }
        }

        onRightImageChanged: {

            if (previewGrid.visible) {

                rightFrame.cache = false
                rightFrame.source = ""
                rightFrame.source = "image://imageprovider/right"
                rightFrame.update()
            }
            else {

                if (frameId == "right") {

                    maximisedPreviewFrame.cache = false
                    maximisedPreviewFrame.source = ""
                    maximisedPreviewFrame.source = "image://imageprovider/right"
                    maximisedPreviewFrame.update()
                }
            }
        }

        onDisp0ImageChanged: {

            if (previewGrid.visible) {

                disp0Frame.cache = false
                disp0Frame.source = ""
                disp0Frame.source = "image://imageprovider/disp0"
                disp0Frame.update()
            }
            else {

                if (frameId == "disp0") {

                    maximisedPreviewFrame.cache = false
                    maximisedPreviewFrame.source = ""
                    maximisedPreviewFrame.source = "image://imageprovider/disp0"
                    maximisedPreviewFrame.update()
                }
            }
        }

        onDisp1ImageChanged: {

            if (previewGrid.visible) {

                disp1Frame.cache = false
                disp1Frame.source = ""
                disp1Frame.source = "image://imageprovider/disp1"
                disp1Frame.update()
            }
            else {

                if (frameId == "disp1") {

                    maximisedPreviewFrame.cache = false
                    maximisedPreviewFrame.source = ""
                    maximisedPreviewFrame.source = "image://imageprovider/disp1"
                    maximisedPreviewFrame.update()
                }
            }
        }

        onFpsUpdated: {

            fpsValTxt.text = fps
        }

        onDepthUpdated: {

            depthValTxt.text = depth
        }
    }

    TitleBar {

        id: titleBar

        title: "TaraXL Studio"
    }

    CamSelector {

        id: cameraSelector

        onCamSelected: {

	    camChanged = 1;
            cam.connectCamera(index)
	    cam.setAccuracyMode(0)
        }

        onResolutionChanged: {

	    if(camChanged == 0)
	            cam.setResolution(index)
	    camChanged = 0;
        }
    }

    SettingsPane {

        id: settings

        onBrightnessChanged: {

            cam.setBrightnessVal(value)
            mainWnd.focus = true
        }

        onExposureChanged: {

            cam.setExposureVal(value)
            mainWnd.focus = true
        }

	onGainChanged: {

            cam.setGainVal(value)
            mainWnd.focus = true
        }

        onAutoExpChecked: {

            if (checked) {

                cam.enableAutoExposure()
		camName = cam.getCameraName();
                if(camName != "1")
		{
			settings.brightnessSliderEnabled = true
                	settings.brightnessValTextEnabled = true
            	}
	    }
            else {

                cam.setExposureVal(exposureVal)
		if(camName != "1")
                {
			settings.brightnessSliderEnabled = false
        	        settings.brightnessValTextEnabled = false
		}
            }
        }

        onHighAccuracyRadioBtnChecked: {

            cam.setAccuracyMode(0)
        }

        onHighFpsRadioBtnChecked: {

            cam.setAccuracyMode(1)
        }

        onUltraAccuracyRadioBtnChecked: {

            cam.setAccuracyMode(2)
        }
    }

    Grid {

        id: maximisedPreviewGrid

        columns: 1
        rows: 1
        spacing: 5

        anchors.left: settings.right
        anchors.leftMargin: spacing
        anchors.top: cameraSelector.bottom
        anchors.topMargin: spacing

        width: parent.width - x - spacing
        height: parent.height - (1.25 * y)

        visible: false

        Rectangle {

            id: maximisedPreviewRect

            width: parent.width
            height: parent.height

            color: "black"

            Image {

                id: maximisedPreviewFrame

                fillMode: Image.PreserveAspectFit

                width: parent.width
                height: parent.height

                MouseArea {

                    id: maximisedMouseArea

                    anchors.fill: parent

                    Timer {

                        id: maximisedImgTimer

                        interval: 200
                        onTriggered: {

                            if (frameId == "disp1") {

                                if (!depthRect.visible)
                                    depthRect.visible = true

                                maxPtClickRect.x = maximisedMouseArea.mouseX
                                maxPtClickRect.y = maximisedMouseArea.mouseY
                                if (!maxPtClickRect.visible)
                                    maxPtClickRect.visible = true

                                cam.getDepth(maximisedMouseArea.mouseX, maximisedMouseArea.mouseY,
                                             maximisedPreviewFrame.width, maximisedPreviewFrame.height)
                            }
                        }
                     }

                    onClicked: {

                         if(maximisedImgTimer.running) {

                             previewGrid.visible = true
                             maximisedPreviewGrid.visible = false
                             maxPtClickRect.visible = false

                             maximisedImgTimer.stop()
                         }
                         else {

                             maximisedImgTimer.restart()
                         }
                     }
                }

                Rectangle {

                    id: maxPtClickRect

                    width: parent.width * 0.01
                    height: width

                    color: "black"
                    border.width: 1
                    radius: width * 0.5

                    visible: false
                }
            }
        }
    }

    Grid {

        id: previewGrid

        columns: 2
        rows: 2
        spacing: 5

        anchors.left: settings.right
        anchors.leftMargin: spacing
        anchors.top: cameraSelector.bottom
        anchors.topMargin: spacing

        width: parent.width - x - spacing
        height: parent.height - (1.25 * y)

        Rectangle {

            id: leftFrameRect

            width: ( parent.width - ( parent.spacing / 2) ) / 2
            height: ( parent.height - ( parent.spacing / 2) ) / 2

            color: "black"

            Image {

                id: leftFrame

                fillMode: Image.PreserveAspectFit

                width: parent.width
                height: parent.height

                MouseArea {

                    anchors.fill: parent

                    onDoubleClicked: {

                        frameId = "left"
                        previewGrid.visible = false
                        maximisedPreviewGrid.visible = true
                    }
                }
            }

            border {

                color: "black"
                width: 2
            }
        }

        Rectangle {

            id: rightFrameRect

            width: ( parent.width - ( parent.spacing / 2) ) / 2
            height: ( parent.height - ( parent.spacing / 2) ) / 2

            color: "black"

            Image {

                id: rightFrame

                fillMode: Image.PreserveAspectFit

                width: parent.width
                height: parent.height

                MouseArea {

                    anchors.fill: parent

                    onDoubleClicked: {

                        frameId = "right"
                        previewGrid.visible = false
                        maximisedPreviewGrid.visible = true
                    }
                }
            }

            border {

                color: "black"
                width: 2
            }
        }

        Rectangle {

            id: disp0Rect

            width: ( parent.width - ( parent.spacing / 2) ) / 2
            height: ( parent.height - ( parent.spacing / 2) ) / 2

            color: "black"

            Image {

                id: disp0Frame

                fillMode: Image.PreserveAspectFit

                width: parent.width
                height: parent.height

                MouseArea {

                    anchors.fill: parent

                    onDoubleClicked: {

                        frameId = "disp0"
                        previewGrid.visible = false
                        maximisedPreviewGrid.visible = true
                    }
                }
            }

            border {

                color: "black"
                width: 2
            }
        }

        Rectangle {

            id: disp1Rect

            width: ( parent.width - ( parent.spacing / 2) ) / 2
            height: ( parent.height - ( parent.spacing / 2) ) / 2

            color: "black"

            Image {

                id: disp1Frame

                fillMode: Image.PreserveAspectFit

                width: parent.width
                height: parent.height

                MouseArea {

                    id: disp1MouseArea

                    anchors.fill: parent

                    Timer {

                        id: disp1Timer

                        interval: 200
                        onTriggered: {

                            if (!depthRect.visible)
                                depthRect.visible = true


                            ptClickRect.x = disp1MouseArea.mouseX
                            ptClickRect.y = disp1MouseArea.mouseY
                            if (!ptClickRect.visible)
                                ptClickRect.visible = true

                            cam.getDepth(disp1MouseArea.mouseX, disp1MouseArea.mouseY,
                                         disp1Frame.width, disp1Frame.height)
                        }
                     }

                     onClicked: {

                         if(disp1Timer.running) {

                             frameId = "disp1"
                             previewGrid.visible = false
                             maximisedPreviewGrid.visible = true
                             ptClickRect.visible = false

                             disp1Timer.stop()
                         }
                         else {

                             disp1Timer.restart()
                         }
                     }
                }

                Rectangle {

                    id: ptClickRect

                    width: parent.width * 0.015
                    height: width

                    color: "black"
                    border.width: 1
                    radius: width * 0.5

                    visible: false
                }
            }

            border {

                color: "black"
                width: 2
            }
        }
    }

    Grid {

        id: fpsAndDepthGrid

        columns: 2
        rows: 1
        spacing: 10

        anchors.top: previewGrid.bottom
        anchors.topMargin: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 5

        width: settings.width
        height: parent.height * 0.04

        Rectangle {

            id: fpsRect

            color: "transparent"

            width: parent.width * 0.30
            height: parent.height

            Text {

                id: fpsTxt

                text: qsTr("FPS:")
                color: "#292929"
                font.bold: true
                font.family: "arial"
            }

            Text {

                id: fpsValTxt

                anchors.left: fpsTxt.right
                anchors.leftMargin: 5

                text: qsTr("")
                horizontalAlignment: Text.AlignRight
                color: "#292929"
                font.family: "arial"
            }
        }

        Rectangle {

            id: depthRect

            color: "transparent"

            width: parent.width * 0.30
            height: parent.height

            visible: false

            Text {

                id: depthTxt

                text: qsTr("Depth :")
                horizontalAlignment: Text.AlignRight
                color: "#292929"
                font.bold: true
                font.family: "arial"
            }

            Text {

                id: depthValTxt

                anchors.left: depthTxt.right
                anchors.leftMargin: 5

                text: qsTr("")
                color: "#292929"
                font.family: "arial"
            }
        }
    }

    Component.onCompleted: {

        cam.getConnectedCameras()
    }
}
}
