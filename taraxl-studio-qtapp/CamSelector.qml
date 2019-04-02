import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

Rectangle {

    id: camConfBar

    x: 0
    y: parent.height * 0.05
    width: parent.width
    height: parent.height * 0.05

    property alias devListModel: cameraComboBox.model
    property alias cameraIndex: cameraComboBox.currentIndex
    signal camSelected(int index)

    property alias resolutionModel: resolutionsComboBox.model
    property alias resolutionIndex: resolutionsComboBox.currentIndex
    signal resolutionChanged(int index)

    LinearGradient {

        anchors.fill: parent

        start: Qt.point(0, 0)
        end: Qt.point(0, parent.height)

        gradient: Gradient {

            GradientStop {

                position: 0.0
                color: "#44464c"
            }

            GradientStop {

                position: 1.0
                color: "#292929"
            }
        }
    }

    Grid {

        id: cameraGrid

        x: 0
        y: 0
        width: parent.width * 0.5
        height: parent.height

        columns: 4
        spacing: 15

        Rectangle {

            id: cameraTxtRect

            x: 0
            y: 0
            width: parent.width * 0.15
            height: parent.height

            color: "transparent"

            Text {

                id: cameraText

                anchors.fill: parent

                text: qsTr("Camera")
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                color: "white"
                font.family: "arial"
                font.pixelSize: parent.width * 0.15
            }
        }

        Rectangle {

            id: cameraDropDownRect

            x: 0
            y: parent.y
            width: cameraComboBox.width
            height: parent.height

            color: "transparent"

            ComboBox {

                id: cameraComboBox

                x: 0
                y: parent.height * 0.25
                height: parent.height * 0.5

                model: devListModel
                currentIndex: cameraIndex

                style: ComboBoxStyle {

                    background: Image {

                        id: camBox

                        fillMode: Image.PreserveAspectFit

                        width: parent.width
                        height: parent.height

                        source: "images/device_box.png"

                        Rectangle {

                            width: camBox.sourceSize.width - 28
                            height: camBox.sourceSize.height
                            color: "white"
                            border.color: "black"
                        }
                    }

                    label:  Text {

                        anchors.fill: parent
                        color: "black"
                        elide: Text.ElideRight
                        text: control.currentText
                        verticalAlignment: Text.AlignVCenter
                        maximumLineCount: 1
                        font.family: "Arial"
                        font.pixelSize: 14
                    }
                }

              /*  onCountChanged: {
                        console.log("Its mei t00\n");


                    if (count > 0) {
                        currentIndex = 0
                        camSelected(currentIndex)
                        resolutionsTxtRect.enabled = true
                        resolutionsDropDownRect.enabled = true
                    }
                    else {

                        resolutionsTxtRect.enabled = false
                        resolutionsDropDownRect.enabled = false
                    }
                }
		*/

                onCurrentIndexChanged: {

                     if (currentIndex != -1) {
                         camSelected(currentIndex)
			 resolutionsTxtRect.enabled = true
                         resolutionsDropDownRect.enabled = true

                         resolutionsComboBox.currentIndex = -1
                         resolutionsComboBox.currentIndex = 0
                     }

                 /*   if (currentText == "") {

                        resolutionsTxtRect.enabled = false
                        resolutionsDropDownRect.enabled = false
                    }
                    else {

                        resolutionsTxtRect.enabled = true
                        resolutionsDropDownRect.enabled = true
                    }
		*/
                }
            }
        }

        Rectangle {

            id: resolutionsTxtRect

            x: 0
            y: 0
            width: parent.width * 0.15
            height: parent.height

            color: "transparent"

            Text {

                id: resolutionsText

                anchors.fill: parent

                text: qsTr("Resolutions")
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                color: "white"
                font.family: "arial"
                font.pixelSize: parent.width * 0.15
            }
        }

        Rectangle {

            id: resolutionsDropDownRect

            x: 0
            y: parent.y
            width: resolutionsComboBox.width
            height: parent.height

            color: "transparent"

            ComboBox {

                id: resolutionsComboBox

                x: 0
                y: parent.height * 0.25
                height: parent.height * 0.5

                model: resolutionModel
                currentIndex: resolutionIndex

                style: ComboBoxStyle {

                    background: Image {

                        id: resBox

                        fillMode: Image.PreserveAspectFit

                        width: parent.width
                        height: parent.height

                        source: "images/device_box.png"

                        Rectangle {

                            width: resBox.sourceSize.width - 28
                            height: resBox.sourceSize.height
                            color: "white"
                            border.color: "black"
                        }
                    }

                    label:  Text {

                        anchors.fill: parent
                        color: "black"
                        elide: Text.ElideRight
                        text: control.currentText
                        verticalAlignment: Text.AlignVCenter
                        maximumLineCount: 1
                        font.family: "Arial"
                        font.pixelSize: 14
                    }
                }

                onCountChanged: {

                    if (count > 0) {

                        currentIndex = 0
                    }
                }

                onCurrentIndexChanged: {
		    if(currentIndex != -1 && cameraComboBox.currentIndex != -1)
	                    resolutionChanged(currentIndex)
                }
            }
        }
    }
}
