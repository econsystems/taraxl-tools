import QtQuick 2.0

Rectangle
{
    id: root
    property alias source: image.source
    property alias imagefillMode: image.fillMode
    property alias imageHeight: image.paintedHeight
    property alias imageWidth: image.paintedWidth
    property alias mouseEnable: mouseArea.enabled
    signal clicked
    width: 64
    height: width
    color: "transparent"

    Image
    {
        id: image
        anchors.fill: parent
        anchors.centerIn: parent
        anchors.margins: 2
        fillMode: Image.PreserveAspectFit
    }
    MouseArea
    {
        id: mouseArea
        anchors.fill: parent
        onClicked: root.clicked();

    }
    states: State {
            name: "pressed"; when: mouseArea.pressed
            PropertyChanges { target: image; scale: 1.2; opacity: 0.3 }
        }

        transitions: Transition {
            NumberAnimation { properties: "scale"; duration: 50; easing.type: Easing.InOutQuad }
        }
}

