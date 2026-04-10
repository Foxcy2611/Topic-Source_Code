import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Window {
    id: wd
    width: 1200
    height: 750
    visible: true
    title: "Smart Home Manager"
    color: theme.mainCL

    property bool isDark: false
    property int currentRoomIndex: 0

    QtObject {
        id: theme
        property color primary: "#4318FF"
        property color secondary: "#6AD2FF"
        property color textDark: wd.isDark ? "#FFFFFF" : "#2B3674"
        property color textGray: wd.isDark ? "#94A3B8" : "#A3AED0"
        property color bgCard: wd.isDark ? "#1E293B" : "#FFFFFF"
        property color inactive: wd.isDark ? "#334155" : "#E0E5F2"
        property color mainCL: wd.isDark ? "#0F172A" : "#F4F7FE"
    }

    property var allDevicesData: [
        [
            { name: "Main Light", icon: "💡", status: true },
            { name: "Smart TV", icon: "📺", status: false },
            { name: "Air Cond", icon: "❄️", status: true },
            { name: "WiFi Router", icon: "📶", status: true },
            { name: "Curtains", icon: "🪟", status: false },
            { name: "Speaker", icon: "🔊", status: false }
        ],
        [
            { name: "Fridge", icon: "🧊", status: true },
            { name: "Oven", icon: "🥧", status: false },
            { name: "Cooker", icon: "🍚", status: false },
            { name: "Kitchen Light", icon: "💡", status: true },
            { name: "Dishwasher", icon: "🍽️", status: false },
            { name: "Coffee Maker", icon: "☕", status: false }
        ],
        [
            { name: "Night Lamp", icon: "🌙", status: true },
            { name: "Air Purifier", icon: "🍃", status: true },
            { name: "Master Bed", icon: "🛏️", status: false },
            { name: "Heater", icon: "🔥", status: false },
            { name: "Projector", icon: "📽️", status: false },
            { name: "Blinds", icon: "🪟", status: true }
        ],
        [
            { name: "Water Heater", icon: "🚿", status: true },
            { name: "Mirror Light", icon: "🪞", status: false },
            { name: "Washing Mc", icon: "🧺", status: false },
            { name: "Dryer", icon: "💨", status: false },
            { name: "Vent Fan", icon: "🌀", status: true },
            { name: "Jacuzzi", icon: "🛁", status: false }
        ],
        [
            { name: "Main Gate", icon: "🚪", status: true },
            { name: "Tesla Charger", icon: "🔋", status: true },
            { name: "Garage Light", icon: "💡", status: false },
            { name: "Tool Box", icon: "🛠️", status: false },
            { name: "Camera", icon: "📹", status: true },
            { name: "Sprinkler", icon: "💦", status: false }
        ]
    ]

    function loadRoomData(index) {
        currentRoomIndex = index
        for (var i = 0; i < roomModel.count; i++) {
            roomModel.get(i).active = false
        }
        roomModel.get(index).active = true
        contentArea.opacity = 0
        fadeTimer.start()
    }

    Timer {
        id: fadeTimer
        interval: 200
        onTriggered: {
            deviceModel.clear()
            var devices = allDevicesData[currentRoomIndex]
            for (var i = 0; i < devices.length; i++) {
                deviceModel.append(devices[i])
            }
            contentArea.opacity = 1
        }
    }

    Component.onCompleted: {
        loadRoomData(0)
    }

    ListModel {
        id: roomModel
        ListElement {
            name: "Living Room"
            icon: "🛋️"
            active: true
        }
        ListElement {
            name: "Kitchen"
            icon: "🍳"
            active: false
        }
        ListElement {
            name: "Bedroom"
            icon: "🛏️"
            active: false
        }
        ListElement {
            name: "Bathroom"
            icon: "🛁"
            active: false
        }
        ListElement {
            name: "Garage"
            icon: "🚗"
            active: false
        }
    }

    ListModel {
        id: deviceModel
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: 280
            color: theme.bgCard

            ColumnLayout {
                anchors.fill: parent
                spacing: 40
                anchors.margins: 30

                Text {
                    text: "SMART HOME™"
                    color: theme.primary
                    font.bold: true
                    font.family: "Arial"
                    font.pixelSize: 26
                }

                ListView {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    model: roomModel
                    spacing: 15
                    clip: true

                    delegate: Rectangle {
                        width: 220
                        height: 60
                        radius: 15
                        color: "transparent"

                        Rectangle {
                            anchors.fill: parent
                            radius: 15
                            visible: active
                            gradient: Gradient {
                                GradientStop {
                                    position: 0.0
                                    color: theme.primary
                                }
                                GradientStop {
                                    position: 1.0
                                    color: theme.secondary
                                }
                            }
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 20
                            anchors.rightMargin: 15
                            spacing: 15

                            Text {
                                text: icon
                                font.pixelSize: 20
                            }

                            Text {
                                text: name
                                font.bold: true
                                font.pixelSize: 16
                                color: active ? "white" : theme.textGray
                            }

                            Item {
                                Layout.fillWidth: true
                            }

                            Text {
                                text: "❯"
                                color: "white"
                                font.pixelSize: 14
                                visible: active
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                loadRoomData(index)
                            }
                        }
                    }
                }

                RowLayout {
                    spacing: 15

                    Rectangle {
                        width: 45
                        height: 45
                        radius: 22.5
                        color: theme.mainCL

                        Text {
                            text: "👤"
                            font.pixelSize: 20
                            anchors.centerIn: parent
                        }
                    }

                    ColumnLayout {
                        spacing: 0

                        Text {
                            text: "Ngoc Chien"
                            font.bold: true
                            font.pixelSize: 16
                            color: theme.textDark
                        }

                        Text {
                            text: "Admin"
                            font.pixelSize: 13
                            color: theme.textGray
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: theme.mainCL

            Behavior on color {
                ColorAnimation {
                    duration: 300
                }
            }

            ColumnLayout {
                id: contentArea
                anchors.fill: parent
                anchors.margins: 40
                spacing: 30

                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                    }
                }

                RowLayout {
                    Layout.fillWidth: true

                    ColumnLayout {
                        Text {
                            text: roomModel.get(currentRoomIndex).name + " Control"
                            font.bold: true
                            font.pixelSize: 30
                            color: theme.textDark
                        }

                        Text {
                            text: "Managing " + deviceModel.count + " devices"
                            font.pixelSize: 20
                            color: theme.textGray
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Row {
                        spacing: 20

                        Repeater {
                            model: [
                                { label: "Temp", val: "24°C", icon: "🌡️" },
                                { label: "Humid", val: "45%", icon: "💧" },
                                { label: "Power", val: "1.2kW", icon: "⚡" }
                            ]

                            delegate: Rectangle {
                                width: 100
                                height: 80
                                radius: 20
                                color: theme.bgCard

                                ColumnLayout {
                                    anchors.centerIn: parent

                                    Text {
                                        text: modelData.icon
                                        font.pixelSize: 24
                                    }

                                    Text {
                                        text: modelData.val
                                        font.bold: true
                                        color: theme.textDark
                                    }

                                    Text {
                                        text: modelData.label
                                        font.pixelSize: 12
                                        color: theme.textGray
                                    }
                                }
                            }
                        }
                    }
                }

                GridLayout {
                    columns: 3
                    columnSpacing: 25
                    rowSpacing: 25
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Repeater {
                        model: deviceModel

                        delegate: Rectangle {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            radius: 25
                            color: theme.bgCard

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 25

                                RowLayout {
                                    Layout.fillWidth: true

                                    Rectangle {
                                        width: 50
                                        height: 50
                                        radius: 15
                                        color: sw.checked ? theme.primary : theme.mainCL

                                        Behavior on color {
                                            ColorAnimation {
                                                duration: 200
                                            }
                                        }

                                        Text {
                                            text: icon
                                            font.pixelSize: 24
                                            anchors.centerIn: parent
                                        }
                                    }

                                    Item {
                                        Layout.fillWidth: true
                                    }

                                    Switch {
                                        id: sw
                                        checked: status

                                        indicator: Rectangle {
                                            implicitWidth: 50
                                            implicitHeight: 30
                                            radius: 15
                                            color: sw.checked ? theme.primary : theme.inactive

                                            Behavior on color {
                                                ColorAnimation {
                                                    duration: 200
                                                }
                                            }

                                            Rectangle {
                                                x: sw.visualPosition * (parent.width - width - 4) + 2
                                                y: 2
                                                width: 26
                                                height: 26
                                                radius: 13
                                                color: "white"
                                            }
                                        }

                                        onToggled: {
                                            model.status = checked
                                        }
                                    }
                                }

                                Item {
                                    Layout.fillHeight: true
                                }

                                ColumnLayout {
                                    spacing: 5

                                    Text {
                                        text: name
                                        color: theme.textDark
                                        font.bold: true
                                        font.pixelSize: 18
                                    }

                                    Text {
                                        text: sw.checked ? "Active" : "Offline"
                                        color: sw.checked ? theme.primary : theme.textGray
                                        font.pixelSize: 15
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 80
                    radius: 20
                    color: theme.primary

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 25

                        Text {
                            text: wd.isDark ? "🌙  Night Mode Enabled" : "☀️ Sun Mode Active"
                            color: "white"
                            font.bold: true
                            font.pixelSize: 18
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        Rectangle {
                            width: 140
                            height: 45
                            radius: 12
                            color: "white"

                            Text {
                                text: "Toggle Mode"
                                color: theme.primary
                                font.bold: true
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onPressed: {
                                    parent.opacity = 0.8
                                }
                                onReleased: {
                                    parent.opacity = 1.0
                                }
                                onClicked: {
                                    wd.isDark = !wd.isDark
                                }
                            }
                        }
                    }

                }
            }
        }
    }
}
