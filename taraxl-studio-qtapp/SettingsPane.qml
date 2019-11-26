import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Rectangle {

    id: settingsPane

    color: "#2a2a2a"
    x: 0
    y: parent.height * 0.10
    width: parent.width * 0.20
    height: parent.height * 0.90

    radius: 2

    property alias brightnessValText: brightnessValTxt.text
    property alias expValText: exposureValTxt.text
    property alias gainValText: gainValTxt.text

    property alias brightnessVal: brightnessSlider.value
    signal brightnessChanged(int value)

    property alias exposureVal: exposureSlider.value
    signal exposureChanged(int value)

    property alias autoExposureChecked: autoExpCheckBox.checked
    signal autoExpChecked(var checked)

    property alias gainVal: gainSlider.value
    signal gainChanged(int value)

    property alias highFpsChecked: highFpsRadioBtn.checked
    signal highFpsRadioBtnChecked()

    property alias highAccuracyChecked: highAccuracyRadioBtn.checked
    signal highAccuracyRadioBtnChecked()

    property alias ultraAccuracyChecked: ultraAccuracyRadioBtn.checked
    signal ultraAccuracyRadioBtnChecked()

    property alias defaultRangeChecked: defaultRangeRadioBtn.checked
    property alias defaultRangeEnabled: defaultRangeRadioBtn.enabled
    signal defaultRangeRadioBtnChecked()

    property alias nearRangeChecked: nearRangeRadioBtn.checked
    property alias nearRangeEnabled: nearRangeRadioBtn.enabled
    signal nearRangeRadioBtnChecked()

    property alias veryNearRangeChecked: veryNearRangeRadioBtn.checked
    property alias veryNearRangeEnabled: veryNearRangeRadioBtn.enabled
    signal veryNearRangeRadioBtnChecked()

    property alias camCtrlRectEnabled: camCtrlsRect.enabled
    property alias algoSettingsRectEnabled: collapsedAlgoSettingsRect.enabled

    property alias brightnessSliderEnabled: brightnessSlider.enabled
    property alias brightnessValTextEnabled: brightnessValTxt.enabled

    property alias exposureValMin: exposureSlider.minimumValue
    property alias exposureValMax: exposureSlider.maximumValue

    property alias gainSliderEnabled: gainSlider.enabled
    property alias gainValTextEnabled: gainValTxt.enabled

    property alias brightnessValMin: brightnessSlider.minimumValue
    property alias brightnessValMax: brightnessSlider.maximumValue


    Grid {

        id: settingsGrid

        x: 5
        y: 5
        width: parent.width - 10
        height: parent.height - 10

        rows: 3
        spacing: 10

        Rectangle {

            id: settingsTxtRect

            x: 0
            y: 0
            width: parent.width
            height: parent.height * 0.05

            color: "#2a2a2a"

            Text {

                id: settingsText

                x: 15
                y: 0
                width: parent.width - x
                height: parent.height

                text: qsTr("Settings")
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                color: "white"
                font.family: "arial"
                font.pixelSize: parent.width * 0.075
            }
        }

        Rectangle {

            id: camCtrlsRect

            x: 0
            y: 0
            width: parent.width
            height: settingsGrid.height * 0.07

            color: "#3a3a3a"

            visible: true
            enabled: camCtrlRectEnabled

            MouseArea {

                anchors.fill: parent

                onClicked: {

                    camCtrlsRect.visible = false
                    expandedCamCtrlsRect.visible = true

                    expandedAlgoSettingsRect.visible = false
                }
            }

            Text {

                id: camCtrlsTxt

                x: 15
                y: 0
                width: parent.width - x
                height: parent.height

                text: qsTr("Camera Controls")
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                color: "white"
                font.family: "arial"
                font.pixelSize: parent.width * 0.075
            }

            Rectangle {

                id: camCtrlsArrowRect

                x: parent.width * 0.90
                y: 0
                width: parent.width * 0.10
                height: parent.height

                color: "transparent"

                ImageButton {

                    id: camCtrlsArrowBtn

                    width: parent.width * 0.6
                    height: parent.height * 0.6
                    anchors.centerIn: parent
                    source: "qrc:/images/dropDownArrow.png"

                    onClicked: {

                        camCtrlsRect.visible = false
                        expandedCamCtrlsRect.visible = true

                        expandedAlgoSettingsRect.visible = false
                    }
                }
            }

            onVisibleChanged: {

                expandedCamCtrlsRect.visible = !visible
            }
        }

        Rectangle {

            id: expandedCamCtrlsRect

            x: 0
            y: 0
            width: parent.width
            height: settingsGrid.height * 0.4

            visible: false

            color: "#3a3a3a"

            Rectangle {

                id: camCtrlsTitleBarRect

                x: 0
                y: 0
                width: parent.width
                height: settingsGrid.height * 0.07

                color: "transparent"

                MouseArea {

                    anchors.fill: parent

                    onClicked: {

                        expandedCamCtrlsRect.visible = false
                        camCtrlsRect.visible = true
                    }
                }


                Text {

                    id: expandedCamCtrlsTxt

                    x: 15
                    y: 0
                    width: parent.width - x
                    height: parent.height

                    text: qsTr("Camera Controls")
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    color: "white"
                    font.family: "arial"
                    font.pixelSize: parent.width * 0.075
                }

                Rectangle {

                    id: expandedCamCtrlsArrowRect

                    x: parent.width * 0.90
                    y: 0
                    width: parent.width * 0.10
                    height: parent.height

                    color: "transparent"

                    ImageButton {

                        id: expandedCamCtrlsArrowBtn

                        width: parent.width * 0.6
                        height: parent.height * 0.6
                        anchors.centerIn: parent
                        source: "qrc:/images/collapseArrow.png"

                        onClicked: {

                            expandedCamCtrlsRect.visible = false
                            camCtrlsRect.visible = true
                        }
                    }
                }
            }

            Rectangle {

                id: camCtrlsSettingsRect

                x: 0
                y: camCtrlsTitleBarRect.height
                width: parent.width
                height: settingsGrid.height * 0.33

                color: "#444444"

                Text {

                    id: brightnessTxt

                    x: 15
                    y: 15
                    width: parent.width - x

                    text: qsTr("Brightness")
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignTop
                    color: "white"
                    font.family: "arial"
                    font.bold: true
                    font.pixelSize: parent.width * 0.06
                }

                Slider {

                    id: brightnessSlider

                    x: 30
                    anchors.top: brightnessTxt.bottom
                    anchors.topMargin: 5
                    width: parent.width * 0.60
                    height: (parent.height * 0.13941)

                    minimumValue: 1
                    maximumValue: 10
                    stepSize: 1

                    updateValueWhileDragging: false

                    value: brightnessVal

                    onValueChanged: {

                        brightnessChanged(value)
                        brightnessValText = value
                    }

                    style: SliderStyle {

                        groove: Rectangle {

                            implicitWidth: exposureSlider.width
                            implicitHeight: 2
                            color: control.enabled ? "white" : "gray"
			    radius: 8
                        }

                        handle: Rectangle {

                            anchors.centerIn: parent
                            color: control.enabled ? "#db6437" : "gray"
		 	    implicitWidth: 15
                            implicitHeight: 15
                            radius: 12
                        }
                    }
                }

                Rectangle {

                    id: brightnessValRect

                    anchors.left: brightnessSlider.right
                    anchors.leftMargin: 10
                    anchors.top: brightnessSlider.top
                    anchors.topMargin: 5

                    width: parent.width * 0.25
                    height: brightnessSlider.height * 0.8

                    radius: 5

                    color: "white"

                    TextField {

                        id: brightnessValTxt

                        width: parent.width
                        height: parent.height

                        text: brightnessSlider.value
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        textColor: "black"

                        maximumLength: 2

                        anchors.centerIn: parent
                        font.pixelSize: parent.height * 0.5

                        validator: IntValidator { }

			onEnabledChanged: {

                            if (enabled) {

                                textColor = "black"
                            }
                            else {

                                textColor = "gray"
                            }
                        }

                        onEditingFinished: {

                            if (text != "") {

                                brightnessSlider.value = text
                                focus = false
                            }
                        }
                    }
                }

                Text {

                    id: exposureTxt

                    x: 15
                    anchors.top: brightnessValRect.bottom
                    anchors.topMargin: 15

                    width: parent.width - x

                    text: qsTr("Exposure")
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignTop
                    color: "white"
                    font.family: "arial"
                    font.bold: true
                    font.pixelSize: parent.width * 0.06
                }

                CheckBox {

                    id: autoExpCheckBox

                    x: 30
                    anchors.top: exposureTxt.bottom
                    anchors.topMargin: 10
                    width: parent.width * 0.60
                    height: parent.height * 0.10

                    style: CheckBoxStyle {

                        label: Text {

                            text: qsTr("Auto Exposure")
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignTop
                            color: "white"
                            font.family: "arial"
                            font.pixelSize: autoExpCheckBox.width * 0.10
                        }
                    }

                    checked: autoExposureChecked

                    onCheckedStateChanged: {

                        if (checked) {

                            exposureSlider.enabled = false
                            exposureValTxt.enabled = false
                        }
                        else {

                            exposureSlider.enabled = true
                            exposureValTxt.enabled = true
                        }

                        autoExpChecked(checked)
                    }
                }

                Slider {

                    id: exposureSlider

                    x: 30
                    anchors.top: autoExpCheckBox.bottom
                    anchors.topMargin: 5
                    width: parent.width * 0.60
                    height: (parent.height * 0.13941)

                    minimumValue: 10
                    maximumValue: 1000000
                    stepSize: 1

                    updateValueWhileDragging: false

                    value: exposureVal

                    onValueChanged: {

                        exposureChanged(value)
                        expValText = value
                    }

                    style: SliderStyle {

                        groove: Rectangle {

                            implicitWidth: exposureSlider.width
                            implicitHeight: 2
                            color: control.enabled ? "white" : "gray"
                            radius: 8
                        }

                        handle: Rectangle {

                            anchors.centerIn: parent
                            color: control.enabled ? "#db6437" : "gray"
                            implicitWidth: 15
                            implicitHeight: 15
                            radius: 12
                        }
                    }
                }

                Rectangle {

                    id: exposureValRect

                    anchors.left: exposureSlider.right
                    anchors.leftMargin: 10
                    anchors.top: exposureSlider.top
                    anchors.topMargin: 5

                    width: parent.width * 0.25
                    height: exposureSlider.height * 0.8

                    radius: 5

                    color: "white"

                    TextField {

                        id: exposureValTxt

                        width: parent.width
                        height: parent.height

                        text: exposureSlider.value
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        textColor: "black"

                        anchors.centerIn: parent
                        font.pixelSize: parent.height * 0.5

                        maximumLength: 7

                        validator: IntValidator { }

                        onEnabledChanged: {

                            if (enabled) {

                                textColor = "black"
                            }
                            else {

                                textColor = "gray"
                            }
                        }

                        onEditingFinished: {

                            if (text != "") {

                                exposureSlider.value = text
                                focus = false
                            }
                        }
                    }

                }


                Text {

                    id: gainTxt

                    x: 15
                    anchors.top: exposureValRect.bottom
                    anchors.topMargin: 15
                    width: parent.width - x

                    text: qsTr("Gain")
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignTop
                    color: "white"
                    font.family: "arial"
                    font.bold: true
                    font.pixelSize: parent.width * 0.06
                }
 Slider {

                    id: gainSlider

                    x: 30
                    anchors.top: gainTxt.bottom
                    anchors.topMargin: 5
                    width: parent.width * 0.60
                    height: (parent.height * 0.13941)

                    minimumValue: 1
                    maximumValue: 240
                    stepSize: 1

                    updateValueWhileDragging: false

                    value: gainVal

                    onValueChanged: {

                        gainChanged(value)
                        gainValText = value
                    }

                    style: SliderStyle {

                        groove: Rectangle {

                            implicitWidth: exposureSlider.width
                            implicitHeight: 2
			    color: control.enabled ? "white" : "gray"
                            radius: 8
                        }

                        handle: Rectangle {

                            anchors.centerIn: parent
			    color: control.enabled ? "#db6437" : "gray"
                            implicitWidth: 15
                            implicitHeight: 15
                            radius: 12
                        }
                    }
                }

                Rectangle {

                    id: gainValRect

                    anchors.left: gainSlider.right
                    anchors.leftMargin: 10
                    anchors.top:gainSlider.top
                    anchors.topMargin: 5

                    width: parent.width * 0.25
                    height: gainSlider.height * 0.8

                    radius: 5

                    color: "white"

                    TextField {

                        id: gainValTxt

                        width: parent.width
                        height: parent.height

                        text: gainSlider.value
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        textColor: "black"

                        maximumLength: 3

                        anchors.centerIn: parent
                        font.pixelSize: parent.height * 0.5

                        validator: IntValidator { }

			onEnabledChanged: {

                            if (enabled) {

                                textColor = "black"
                            }
                            else {

                                textColor = "gray"
                            }
                        }


                        onEditingFinished: {

                            if (text != "") {

                                gainSlider.value = text
                                focus = false
                            }
                        }
                    }
                }
            }

            onVisibleChanged: {

                camCtrlsRect.visible = !visible
            }
        }

        Rectangle {

            id: collapsedAlgoSettingsRect

            x: 0
            y: 0
            width: parent.width
            height: settingsGrid.height * 0.07

            color: "#3a3a3a"

            visible: true
            enabled: algoSettingsRectEnabled

            MouseArea {

                anchors.fill: parent

                onClicked: {

                    expandedAlgoSettingsRect.visible = true
                    collapsedAlgoSettingsRect.visible = false

                    expandedCamCtrlsRect.visible = false
                }
            }

            Text {

                id: algoSettingsTxt

                x: 15
                y: 0
                width: parent.width - x
                height: parent.height

                text: qsTr("Algorithm Settings")
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                color: "white"
                font.family: "arial"
                font.pixelSize: parent.width * 0.075
            }

            Rectangle {

                id: algoSettingsArrowRect

                x: parent.width * 0.90
                y: 0
                width: parent.width * 0.10
                height: parent.height

                color: "transparent"

                ImageButton {

                    id: algoSettingsArrowBtn

                    width: parent.width * 0.6
                    height: parent.height * 0.6
                    anchors.centerIn: parent
                    source: "qrc:/images/dropDownArrow.png"

                    onClicked: {

                        expandedAlgoSettingsRect.visible = true
                        collapsedAlgoSettingsRect.visible = false

                        expandedCamCtrlsRect.visible = false
                    }
                }
            }

            onVisibleChanged: {

                expandedAlgoSettingsRect.visible = !visible
            }
        }

        Rectangle {

            id: expandedAlgoSettingsRect

            x: 0
            y: 0
            width: parent.width
            height: settingsGrid.height * 0.17

            visible: false

            color: "#3a3a3a"

            Rectangle {

                id: algoSettingsTitleBarRect

                x: 0
                y: 0
                width: parent.width
                height: settingsGrid.height * 0.07

                color: "transparent"

                MouseArea {

                    anchors.fill: parent

                    onClicked: {

                        expandedAlgoSettingsRect.visible = false
                        collapsedAlgoSettingsRect.visible = true
                    }
                }

                Text {

                    id: expandedAlgoSettingsTxt

                    x: 15
                    y: 0
                    width: parent.width - x
                    height: parent.height

                    text: qsTr("Algorithm Settings")
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    color: "white"
                    font.family: "arial"
                    font.pixelSize: parent.width * 0.075
                }

                Rectangle {

                    id: expandedAlgoSettingsArrowRect

                    x: parent.width * 0.90
                    y: 0
                    width: parent.width * 0.10
                    height: parent.height

                    color: "transparent"

                    ImageButton {

                        id: expandedAlgoSettingsArrowBtn

                        width: parent.width * 0.6
                        height: parent.height * 0.6
                        anchors.centerIn: parent
                        source: "qrc:/images/collapseArrow.png"

                        onClicked: {

                            expandedAlgoSettingsRect.visible = false
                            collapsedAlgoSettingsRect.visible = true
                        }
                    }
                }
            }

            Rectangle {

                id: algoSettingsRect

                x: 0
                y: algoSettingsTitleBarRect.height
                width: parent.width
                height: settingsGrid.height * 0.40

                color: "#444444"

                ExclusiveGroup {

                    id: algoSettingsGrp
                }
                Text {

                    id: algorithmModeText

                    x: 15
                    anchors.top: parent.top
                    anchors.topMargin: 15

                    width: parent.width - x

                    text: qsTr("Algorithm mode")
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignTop
                    color: "white"
                    font.family: "arial"
                    font.bold: true
                    font.pixelSize: parent.width * 0.06
                }
                RadioButton {

                    id: highFpsRadioBtn

                    x: parent.width * 0.20
                    
                    anchors.top: algorithmModeText.bottom
                    anchors.topMargin: 15

                    width: parent.width * 0.60

                    style: RadioButtonStyle {

                        spacing: 10
                        label: Text {

                            text: qsTr("High Frame Rate")
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            color: "white"
                            font.family: "arial"
                            font.pixelSize: algoSettingsRect.width * 0.06
                        }

                        indicator: Rectangle {

                            implicitWidth: 15
                            implicitHeight: 15
                            radius: 8
                            border.color: control.activeFocus ? "darkblue" : "gray"
                            border.width: 1

                            Rectangle {

                                anchors.fill: parent
                                visible: control.checked
                                color: "#555"
                                radius: 9
                                anchors.margins: 4
                            }
                        }
                    }
                    exclusiveGroup: algoSettingsGrp
                    checked: highFpsChecked

                    onCheckedChanged: {

                        if (checked) {

                            highFpsRadioBtnChecked()
                        }
                    }
                }

                RadioButton {

                    id: highAccuracyRadioBtn

                    x: parent.width * 0.20
                    anchors.top: highFpsRadioBtn.bottom
                    anchors.topMargin: 15

                    width: parent.width * 0.60

                    style: RadioButtonStyle {

                        spacing: 10
                        label: Text {

                            text: qsTr("High Accuracy")
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            color: "white"
                            font.family: "arial"
                            font.pixelSize: algoSettingsRect.width * 0.06
                        }

                        indicator: Rectangle {

                            implicitWidth: 15
                            implicitHeight: 15
                            radius: 8
                            border.color: control.activeFocus ? "darkblue" : "gray"
                            border.width: 1

                            Rectangle {

                                anchors.fill: parent
                                visible: control.checked
                                color: "#555"
                                radius: 9
                                anchors.margins: 4
                            }
                        }
                    }
                    exclusiveGroup: algoSettingsGrp
                    checked: highAccuracyChecked

                    onCheckedChanged: {

                        if(checked) {

                            highAccuracyRadioBtnChecked()
                        }
                    }
                }
                RadioButton {

                    id: ultraAccuracyRadioBtn

                    x: parent.width * 0.20
                    anchors.top: highAccuracyRadioBtn.bottom
                    anchors.topMargin: 15

                    width: parent.width * 0.60

                    style: RadioButtonStyle {

                        spacing: 10
                        label: Text {

                            text: qsTr("Ultra accuracy")
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            color: "white"
                            font.family: "arial"
                            font.pixelSize: algoSettingsRect.width * 0.06
                        }

                        indicator: Rectangle {

                            implicitWidth: 15
                            implicitHeight: 15
                            radius: 8
                            border.color: control.activeFocus ? "darkblue" : "gray"
                            border.width: 1

                            Rectangle {

                                anchors.fill: parent
                                visible: control.checked
                                color: "#555"
                                radius: 9
                                anchors.margins: 4
                            }
                        }
                    }
                    exclusiveGroup: algoSettingsGrp
                    checked: ultraAccuracyChecked

                    onCheckedChanged: {

                        if(checked) {

                            ultraAccuracyRadioBtnChecked()
                        }
                    }
                }
                ExclusiveGroup {

                    id: rangeSettingsGroup
                }
                Text {

                    id: depthRangeText

                    x: 15
                    anchors.top: ultraAccuracyRadioBtn.bottom
                    anchors.topMargin: 15

                    width: parent.width - x

                    text: qsTr("Depth range")
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignTop
                    color: "white"
                    font.family: "arial"
                    font.bold: true
                    font.pixelSize: parent.width * 0.06
                }
                RadioButton {

                    id: defaultRangeRadioBtn

                    x: parent.width * 0.20
                    
                    anchors.top: depthRangeText.bottom
                    anchors.topMargin: 15

                    width: parent.width * 0.60

                    style: RadioButtonStyle {

                        spacing: 10
                        label: Text {

                            text: qsTr("Default Range")
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            color: parent.enabled? "white" : "gray"
                            font.family: "arial"
                            font.pixelSize: algoSettingsRect.width * 0.06
                        }

                        indicator: Rectangle {

                            implicitWidth: 15
                            implicitHeight: 15
                            radius: 8
                            border.color: control.activeFocus ? "darkblue" : "gray"
                            border.width: 1

                            Rectangle {

                                anchors.fill: parent
                                visible: control.checked
                                color: "#555"
                                radius: 9
                                anchors.margins: 4
                            }
                        }
                    }
                    exclusiveGroup: rangeSettingsGroup
                    checked: defaultRangeChecked
			
                    onCheckedChanged: {

                        if (checked) {

                            defaultRangeRadioBtnChecked()
                        }
                    }
                }

                RadioButton {

                    id: nearRangeRadioBtn

                    x: parent.width * 0.20
                    anchors.top: defaultRangeRadioBtn.bottom
                    anchors.topMargin: 15

                    width: parent.width * 0.60

                    style: RadioButtonStyle {

                        spacing: 10
                        label: Text {

                            text: qsTr("Near range")
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            color: parent.enabled? "white" : "gray"
                            font.family: "arial"
                            font.pixelSize: algoSettingsRect.width * 0.06
                        }

                        indicator: Rectangle {

                            implicitWidth: 15
                            implicitHeight: 15
                            radius: 8
                            border.color: control.activeFocus ? "darkblue" : "gray"
                            border.width: 1

                            Rectangle {

                                anchors.fill: parent
                                visible: control.checked
                                color: "#555"
                                radius: 9
                                anchors.margins: 4
                            }
                        }
                    }
                    exclusiveGroup: rangeSettingsGroup
                    checked: nearRangeChecked

                    onCheckedChanged: {

                        if(checked) {

                            nearRangeRadioBtnChecked()
                        }
                    }
                }
                RadioButton {

                    id: veryNearRangeRadioBtn

                    x: parent.width * 0.20
                    anchors.top: nearRangeRadioBtn.bottom
                    anchors.topMargin: 15

                    width: parent.width * 0.60

                    style: RadioButtonStyle {

                        spacing: 10
                        label: Text {

                            text: qsTr("Very near range")
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            color: parent.enabled? "white" : "gray"
                            font.family: "arial"
                            font.pixelSize: algoSettingsRect.width * 0.06
                        }

                        indicator: Rectangle {

                            implicitWidth: 15
                            implicitHeight: 15
                            radius: 8
                            border.color: control.activeFocus ? "darkblue" : "gray"
                            border.width: 1

                            Rectangle {

                                anchors.fill: parent
                                visible: control.checked
                                color: "#555"
                                radius: 9
                                anchors.margins: 4
                            }
                        }
                    }
                    exclusiveGroup: rangeSettingsGroup
                    checked: veryNearRangeChecked

                    onCheckedChanged: {

                        if(checked) {

                            veryNearRangeRadioBtnChecked()
                        }
                    }
                }
                onVisibleChanged: {

                    collapsedAlgoSettingsRect.visible = !visible
                }
            }
        }
    }
}
