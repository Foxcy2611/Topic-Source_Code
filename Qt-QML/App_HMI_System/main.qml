import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Window {
    id: mainWindow
    width: 1280
    height: 720
    visible: true
    title: "HMI CONTROL SYSTEM - V1 LIMITED VERSION"

    QtObject {
        id: theme
        property color bgBase: "#090B10"
        property color bgPanel: "#151822"
        property color primary: "#00E5FF"
        property color accent: "#FFAB00"
        property color danger: "#FF1744"
        property color success: "#00E676"
        property color textMain: "#E0E0E0"
        property color textMuted: "#455A64"
    }

    color: theme.bgBase
    property bool globalEStop: false // Tắt hết mọi thứ
    property bool isTurnOn: false

    property int pumpRpm: 0 // motor RPM
    property real systemPressure: 0.0 // core pressure
    property real powerLoad: 0.0 // kW
    property real battery: 85.0 // backup bat
    property real coreTemp: 25.0 //

    Timer {
        interval: 100
        repeat: true
        running: true

        onTriggered: {
            if(! mainWindow.globalEStop){
                pumpRpm = 1450 + (Math.random() * 50) - 25
                systemPressure = 4.5 + (Math.random() * 0.2) - 0.1
                powerLoad = 65.0 + (Math.random() * 10) - 5
                if(coreTemp <= 85.0) coreTemp += 0.5

                if(isTurnOn){
                    if(battery < 100) {
                        battery += 0.01
                    } else {
                        isTurnOn = false
                    }
                } else {
                    if(battery > 0){
                        battery -= 0.01
                    } else {
                        isTurnOn = true
                    }
                }
            } else {
                pumpRpm = 0
                systemPressure = 0.0
                powerLoad = 0
                if(coreTemp > 25.0) coreTemp -= 1.0
            }
        }
    }

    Component {
        id: pageDashboard

        Rectangle {
            color: theme.bgBase

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 30
                spacing: 20

                Text {
                    text: "TỔNG QUAN HỆ THỐNG TRẠM"
                    font.letterSpacing: 2
                    font.pixelSize: 32
                    font.bold: true
                    color: theme.textMain
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 250
                    spacing: 30

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        color: theme.bgPanel
                        radius: 8
                        border.width: 2
                        border.color: mainWindow.globalEStop ? theme.danger : theme.textMuted

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 10

                            Text {
                                text: "MOTOR RPM"
                                font.pixelSize: 18
                                color: theme.textMuted
                                Layout.alignment: Qt.AlignHCenter
                            }

                            Text {
                                text: Math.round(pumpRpm)
                                font.bold: true
                                font.pixelSize: 80
                                color: mainWindow.globalEStop ? theme.danger : theme.primary
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        color: theme.bgPanel
                        radius: 8
                        border.width: 2
                        border.color: mainWindow.globalEStop ? theme.danger : theme.textMuted

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 10

                            Text {
                                text: "CORE PRESSURE (Bar)"
                                font.pixelSize: 18
                                color: theme.textMuted
                                Layout.alignment: Qt.AlignHCenter
                            }

                            Text {
                                text: systemPressure.toFixed(2)
                                font.bold: true
                                font.pixelSize: 80
                                color: mainWindow.globalEStop ? theme.danger : theme.primary
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: pageRoboticArm

        Rectangle {
            color: theme.bgPanel

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 30
                spacing: 20

                Text {
                    text: "ĐIỀU KHIỂN ROBOTIC ARM (6 DOF)"
                    font.bold: true
                    font.pixelSize: 32
                    color: theme.textMain
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    radius: 8
                    color: theme.bgPanel
                    border.color: theme.textMuted
                    border.width: 2

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 30
                        spacing: 30

                        Repeater {
                            model: [
                                {name: "AXIS 31 (BASE)", min: -100, max: 100, val: 0},
                                {name: "AXIS 32 (SHOULDER)", min: -90, max: 90, val: 45},
                                {name: "AXIS J3 (ELBOW)", min: -150, max: 150, val: 0}
                            ]

                            ColumnLayout {
                                spacing: 0
                                Layout.fillWidth: true
                                property real valu: modelData.val

                                RowLayout {
                                    id: tt
                                    Layout.fillWidth: true

                                    Text {
                                        text: modelData.name
                                        font.bold: true
                                        font.pixelSize: 18
                                        color: theme.primary
                                        Layout.fillWidth: true
                                    }

                                    Item {
                                        Layout.fillWidth: true
                                    }

                                    Text {
                                        text: Math.round(sld.value) + " %"
                                        font.bold: true
                                        font.pixelSize: 25
                                        color: theme.textMain
                                    }
                                }

                                Slider {
                                    id: sld
                                    from: modelData.min
                                    to: modelData.max
                                    value: valu
                                    enabled: !globalEStop
                                    Layout.fillWidth: true

                                    background: Rectangle {
                                        width: parent.availableWidth
                                        height: 6
                                        color: theme.textMuted
                                        radius: 3

                                        Rectangle {
                                            width: sld.visualPosition * parent.width
                                            height: 6
                                            radius: 3
                                            color: mainWindow.globalEStop ? theme.danger : theme.primary
                                        }
                                    }

                                    handle: Rectangle {
                                        x: sld.leftPadding + sld.visualPosition * (sld.availableWidth - width)
                                        y: sld.topPadding + sld.availableHeight / 2 - height / 2
                                        width: 20
                                        height: 20
                                        radius: 10
                                        color: theme.bgBase
                                        border.width: 2
                                        border.color: theme.primary
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: pagePowerGrid

        Rectangle {
            color: "transparent"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 30
                spacing: 20

                Text {
                    text: "HỆ THỐNG NĂNG LƯỢNG & UPS"
                    font.bold: true
                    font.pixelSize: 32
                    color: theme.textMain
                }

                RowLayout {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    spacing: 30

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        radius: 8
                        color: theme.bgPanel
                        border.width: 2
                        border.color: theme.textMuted

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 40
                            spacing: 20

                            Text {
                                text: "TỔNG TẢI TIÊU THỤ"
                                font.bold: true
                                font.pixelSize: 20
                                color: mainWindow.powerLoad > 70 ? theme.danger : (mainWindow.powerLoad > 50 ? theme.accent : theme.success)
                                Layout.alignment: Qt.AlignHCenter
                            }

                            Text {
                                text: mainWindow.powerLoad.toFixed(1) + " %"
                                font.bold: true
                                font.pixelSize: 90
                                color: mainWindow.globalEStop ? theme.primary : theme.accent
                                Layout.alignment: Qt.AlignHCenter
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 60
                                color: theme.bgPanel
                                radius: 30
                                border.width: 3
                                border.color: theme.textMuted
                                clip: true

                                Rectangle {
                                    height: parent.height
                                    width: parent.width * (mainWindow.powerLoad / 100.0)
                                    radius: 30
                                    color: mainWindow.powerLoad > 70 ? theme.danger : (mainWindow.powerLoad > 50 ? theme.accent : theme.success)

                                    Behavior on width {
                                        NumberAnimation {
                                            duration: 150
                                        }
                                    }

                                    Behavior on color {
                                        ColorAnimation {
                                            duration: 400
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 400
                        radius: 8
                        color: theme.bgPanel
                        border.width: 2
                        border.color: theme.textMuted

                        ColumnLayout {
                            anchors.margins: 30
                            spacing: 25
                            anchors.fill: parent

                            Text {
                                text: "BACKUP BATTERY"
                                font.bold: true
                                font.pixelSize: 20
                                color: theme.textMuted
                            }

                            Rectangle {
                                id: batt
                                Layout.alignment: Qt.AlignHCenter
                                width: 150
                                height: 250
                                color: "transparent"
                                border.width: 4
                                border.color: theme.textMain
                                radius: 10


                                Rectangle {
                                    width: 40
                                    height: 15
                                    color: theme.textMain
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.bottom: parent.top
                                }

                                Rectangle {
                                    width: parent.width - 10
                                    height: (parent.height - 10) * (mainWindow.battery / 100.0)
                                    color: mainWindow.battery > 80 ? theme.success : (mainWindow.battery > 40 ? theme.accent : theme.danger)
                                    radius: 6
                                    anchors.bottom: parent.bottom
                                    anchors.bottomMargin: 6
                                    anchors.horizontalCenter: parent.horizontalCenter

                                    ColumnLayout {
                                        anchors.centerIn: parent
                                        spacing: 5

                                        Text {
                                            text: mainWindow.battery.toFixed(1) + " %"
                                            font.bold: true
                                            font.pixelSize: 36
                                            color: theme.bgBase
                                        }

                                        Text {
                                            text: "⚡"
                                            font.bold: true
                                            font.pixelSize: 80
                                            color: theme.textMuted
                                            visible: mainWindow.isTurnOn
                                            Layout.alignment: Qt.AlignHCenter
                                        }
                                    }

                                }
                            }

                            Button {
                                Layout.preferredHeight: 50
                                Layout.preferredWidth: 100
                                Layout.alignment: Qt.AlignHCenter
                                enabled: ! mainWindow.globalEStop
                                background: Rectangle {
                                    color: mainWindow.globalEStop ? theme.danger : theme.primary
                                    border.width: 2
                                    border.color: theme.textMain
                                    radius: 15

                                }

                                contentItem: Text {
                                    text: mainWindow.isTurnOn ? "Turn Off" : "Turn On"
                                    color: theme.bgBase
                                    font.bold: true
                                    font.pixelSize: 20
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.horizontalAlignment
                                }

                                onClicked: {
                                    mainWindow.isTurnOn = !mainWindow.isTurnOn
                                }
                            }

                            RowLayout {
                                Layout.fillHeight: true

                                Text {
                                    text: "VOLTAGE:"
                                    font.pixelSize: 18
                                    color: theme.textMuted
                                }

                                Item {
                                    Layout.fillWidth: true
                                }

                                Text {
                                    text: "412 VDC"
                                    font.bold: true
                                    font.pixelSize: 22
                                    color: theme.primary
                                }
                            }

                            RowLayout {
                                Layout.fillHeight: true

                                Text {
                                    text: "DISCHARGE:"
                                    font.pixelSize: 18
                                    color: theme.textMuted
                                }

                                Item {
                                    Layout.fillWidth: true
                                }

                                Text {
                                    text: "15.4 A"
                                    font.bold: true
                                    font.pixelSize: 22
                                    color: theme.accent
                                }
                            }
                        }
                    }
                }
            }
        }
    }
//
    Component {
        id: pageHVAC

        Rectangle {
            color: "transparent"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 30
                spacing: 20

                Text {
                    text: "HỆ THỐNG TẢN NHIỆT (HVAC)"
                    font.bold: true
                    font.pixelSize: 32
                    font.letterSpacing: 2
                    color: theme.textMain
                }

                RowLayout {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    spacing: 30

                    Rectangle {
                        Layout.preferredWidth: 300
                        Layout.fillHeight: true
                        color: theme.bgPanel
                        radius: 10
                        border.width: 3
                        border.color: theme.textMuted

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 20

                            Text {
                                text: "CORE TEMP"
                                font.bold: true
                                font.pixelSize: 20
                                color: theme.textMuted
                                Layout.alignment: Qt.AlignHCenter
                                Layout.topMargin: 25
                            }

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                Rectangle {
                                    width: 60
                                    height: parent.height - 40
                                    anchors.centerIn: parent
                                    border.color: theme.textMuted
                                    border.width: 3
                                    radius: 30
                                    color: "transparent"

                                    Rectangle {
                                        width: parent.width - 8
                                        anchors.bottom: parent.bottom
                                        anchors.bottomMargin: 4
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        radius: 26
                                        height: (parent.height - 8) * (mainWindow.coreTemp / 100.0)
                                        gradient: Gradient {
                                                GradientStop { position: 0.0; color: theme.danger }
                                                GradientStop { position: 0.5; color: theme.accent }
                                                GradientStop { position: 1.0; color: theme.primary
                                            }
                                        }

                                        Behavior on height {
                                            NumberAnimation {
                                                duration: 150
                                            }
                                        }
                                    }
                                }
                            }

                            Text {
                                text: mainWindow.coreTemp.toFixed(1) + " °C"
                                color: mainWindow.coreTemp > 50 ? theme.danger : theme.textMain
                                font.bold: true
                                font.pixelSize: 40
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        border.width: 3
                        border.color: theme.textMuted
                        radius: 10
                        color: theme.bgPanel

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 20

                            Text {
                                text: "EXHAUST FANS MATRIX"
                                font.pixelSize: 20
                                font.bold: true
                                color: theme.textMuted
                            }

                            GridLayout {
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                columns: 3
                                columnSpacing: 30
                                rowSpacing: 30

                                Repeater {
                                    model: 6

                                    Rectangle {
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                        color: theme.bgBase
                                        border.width: 2
                                        border.color: theme.primary
                                        radius: 10

                                        Text {
                                            text: "⚙️"
                                            font.bold: true
                                            font.pixelSize: 80
                                            color: theme.textMain
                                            anchors.centerIn: parent

                                            RotationAnimation on rotation {
                                                loops: Animation.Infinite
                                                from: 0
                                                to: 360
                                                duration: 300
                                                running: ! mainWindow.globalEStop
                                            }
                                        }

                                        Text {
                                            text: "FAN " + index
                                            font.bold: true
                                            font.pixelSize: 20
                                            color: theme.primary
                                            anchors.bottom: parent.bottom
                                            anchors.horizontalCenter: parent.horizontalCenter
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: pageLogs

        Rectangle {
            color: "transparent"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 30
                spacing: 30

                Text {
                    text: "SYSTEM LOGS & UART TERMINAL"
                    font.bold: true
                    font.pixelSize: 32
                    color: theme.textMain
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    border.width: 3
                    border.color: theme.textMuted
                    color: theme.bgBase

                    ListModel {
                        id: logModel
                    }

                    Timer {
                        interval: 1000
                        repeat: true
                        running: true

                        onTriggered: {
                            var t = Qt.formatTime(new Date(), "hh:mm:ss")
                            var msgs = [
                                        "INFO: NODE STM32_01 ping OK",
                                        "INFO: Syncing RTC ...",
                                        "RX: [0x4A 0x26 0xFF]",
                                        "WARN: MEMORY LOAD AT 75%"
                                    ];

                            if(mainWindow.globalEStop){
                                msgs = [
                                        "FATAL: EMERGENCY STOP TRIGGERED !!",
                                        "FATAL: ALL MOTORS HALTED !!"
                                        ];
                            }

                            var msg = msgs[Math.floor(Math.random() * msgs.length)];

                            var col = (msg.indexOf("FATAL") !== -1 ? theme.danger : (msg.indexOf("WARN") !== -1 ? theme.accent : theme.primary)).toString();

                            logModel.insert(0, { "time": t, "msg": msg, "msgColor": col });
                            if (logModel.count > 100) logModel.remove(100);
                        }
                    }
                    ListView {
                        anchors.fill: parent
                        anchors.margins: 15
                        clip: true
                        model: logModel
                        spacing: 4
                        delegate: Text {
                            text: "[" + model.time + "] > " + model.msg

                            color: model.msgColor
                            font.family: "Monospace"
                            font.pixelSize: 16
                        }
                    }
                }
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 70
            color: theme.bgPanel
            border.color: theme.danger
            border.width: mainWindow.globalEStop ? 3 : 0

            RowLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 20

                Text {
                    text: "⚡ SCADA CORE v3.0 (ULTIMATE)"
                    font.bold: true
                    font.pixelSize: 22
                    color: theme.primary
                }

                Item {
                    Layout.fillWidth: true
                }

                Text {
                    text: "SYS STATUS:"
                    font.bold: true
                    font.pixelSize: 16
                    color: theme.textMuted
                }

                Text {
                    text: mainWindow.globalEStop ? "HALTED" : "ONLINE"
                    font.bold: true
                    font.pixelSize: 20
                    color: mainWindow.globalEStop ? theme.danger : theme.primary
                }

                Item {
                    Layout.preferredWidth: 40
                }

                Button {
                    Layout.preferredWidth: 160
                    Layout.fillHeight: true
                    text: mainWindow.globalEStop ? "RESET E-STOP" : "EMERGENCY STOP"

                    background: Rectangle {
                        border.color: "white"
                        border.width: mainWindow.globalEStop ? 3 : 0
                        color: theme.danger
                        radius: 4
                    }

                    contentItem: Text {
                        text: parent.text
                        font.pixelSize: 16
                        font.bold: true
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        mainWindow.globalEStop = ! mainWindow.globalEStop
                    }
                }
            }
        }

        RowLayout {
            spacing: 0
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: 280
                color: theme.bgPanel
                border.width: 1
                border.color: theme.textMuted

                ColumnLayout {
                    id: menuItem

                    spacing: 0
                    anchors.fill: parent
                    property int selectIndex: -1

                    Repeater {
                        id: repe
                        model: [
                            { name: "TỔNG QUAN (DASHBOARD)", icon: "📊"},
                            { name: "ĐIỀU KHIỂN ROBOTIC", icon: "🦾"},
                            { name: "QUẢN LÝ ĐIỆN NĂNG", icon: "⚡"},
                            { name: "HỆ THỐNG GIẢI NHIỆT", icon: "❄️"},
                            { name: "TRẠM LOGS / UART", icon: "💻" }

                        ]

                        Rectangle {

                            Layout.fillWidth: true
                            Layout.preferredHeight: 70

                            color: index === menuItem.selectIndex ? theme.textMuted : "transparent"

                            Rectangle {
                                width: 5
                                height: parent.height
                                color: theme.primary
                                visible: index === menuItem.selectIndex
                            }

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 20
                                spacing: 20

                                Text {
                                    text: modelData.icon
                                    font.pixelSize: 24
                                }

                                Text {
                                    text: modelData.name
                                    font.bold: true
                                    font.pixelSize: 16
                                    color: (index === menuItem.selectIndex) ? theme.primary : theme.textMain
                                }
                            }

                            MouseArea {
                                anchors.fill: parent

                                onClicked: {
                                    menuItem.selectIndex = index

                                    if(index === 0){
                                        stkView.replace(pageDashboard)
                                    } else if(index === 1){
                                        stkView.replace(pageRoboticArm)
                                    } else if(index === 2){
                                        stkView.replace(pagePowerGrid)
                                    } else if(index === 3){
                                        stkView.replace(pageHVAC)
                                    } else if(index === 4){
                                        stkView.replace(pageLogs)
                                    }
                                }
                            }
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                    }
                }
            }

            StackView {
                id: stkView
                Layout.fillHeight: true
                Layout.fillWidth: true
                initialItem: pageDashboard

                replaceEnter: Transition {
                    NumberAnimation {
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 200
                    }
                }
                replaceExit: Transition {
                    NumberAnimation {
                        property: "opacity"
                        from: 1
                        to: 0
                        duration: 200
                    }
                }
            }
        }
    }
}
