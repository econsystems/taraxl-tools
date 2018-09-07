import QtQuick 2.0

Rectangle {

    id: applicationHeader

    color: "#2a2a2a"
    width: parent.width
    height: parent.height * 0.05

    property alias title: applicationName.text

    Rectangle {

        id: closeRect
        color: "transparent"
        width: parent.width * 0.03
        height: parent.height

        ImageButton {

            id: exitBtn
            width: parent.width * 0.6
            height: parent.height * 0.6
            anchors.centerIn: parent
            source: "qrc:/images/close.png"

            onClicked: Qt.quit();
        }
    }

    Rectangle {

        id: nameRect
        color: "transparent"
        x: exitBtn.width
        width: parent.width - (closeRect.width)
        height: parent.height

        Text {

            id: applicationName
            x: 0
            y: 0
            color: "White"
            anchors.fill: parent
            font.family: "Arial"
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.width * 0.02
        }
    }
}
