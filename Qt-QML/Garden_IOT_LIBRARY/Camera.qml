import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    color: "transparent"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 30
        spacing: 25

        Text {
            text: "📷 HỆ THỐNG CAMERA AN NINH"
            font.pixelSize: 32
            font.bold: true
            color: theme.textMain
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 30

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: theme.camColor
                radius: 16
                border.color: theme.border
                border.width: 2
                clip: true

                Grid {
                    anchors.fill: parent
                    columns: 10
                    spacing: 0
                    opacity: 0.1

                    Repeater {
                        model: 100

                        Rectangle {
                            width: parent.width/10
                            height: width
                            color: "transparent"
                            border.color: "#FFFFFF"
                            border.width: 1
                        }
                    }
                }

                RowLayout {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.margins: 20
                    spacing: 10

                    Rectangle {
                        width: 16
                        height: 16
                        radius: 8
                        color: theme.danger

                        SequentialAnimation on opacity {
                            loops: Animation.Infinite

                            NumberAnimation {
                                to: 0
                                duration: 800
                            }

                            NumberAnimation {
                                to: 1
                                duration: 800
                            }
                        }
                    }

                    Text {
                        text: "LIVE CAM 01 - ZONE A"
                        color: "#FFFFFF"
                        font.pixelSize: 18
                        font.bold: true
                        font.family: "Monospace"
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: "📡 Đang truyền phát tín hiệu Video..."
                    color: theme.textMuted
                    font.pixelSize: 20
                }
            }

            Rectangle {
                Layout.preferredWidth: 300
                Layout.fillHeight: true
                color: theme.bgCard
                radius: 16
                border.color: theme.border
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 30
                    spacing: 20

                    Text {
                        text: "ĐIỀU KHIỂN GÓC QUAY"
                        font.pixelSize: 18
                        font.bold: true
                        color: theme.textMuted
                        Layout.alignment: Qt.AlignHCenter
                    }

                    GridLayout {
                        Layout.alignment: Qt.AlignHCenter
                        columns: 3
                        columnSpacing: 10
                        rowSpacing: 10
                        Layout.topMargin: 20

                        Item {
                            width: 60
                            height: 60
                        }

                        Button {
                            width: 60
                            height: 60
                            text: "▲"
                            font.pixelSize: 24

                            background: Rectangle {
                                color: theme.bgBase
                                radius: 8
                            }
                        }

                        Item {
                            width: 60
                            height: 60
                        }

                        Button {
                            width: 60
                            height: 60
                            text: "◀"
                            font.pixelSize: 24

                            background: Rectangle {
                                color: theme.bgBase
                                radius: 8
                            }
                        }

                        Button {
                            width: 60
                            height: 60
                            text: "⏺"
                            font.pixelSize: 24

                            background: Rectangle {
                                color: theme.border
                                radius: 30
                            }
                        }

                        Button {
                            width: 60
                            height: 60
                            text: "▶"
                            font.pixelSize: 24

                            background: Rectangle {
                                color: theme.bgBase
                                radius: 8
                            }
                        }

                        Item {
                            width: 60
                            height: 60
                        }

                        Button {
                            width: 60
                            height: 60
                            text: "▼"
                            font.pixelSize: 24

                            background: Rectangle {
                                color: theme.bgBase
                                radius: 8
                            }
                        }

                        Item {
                            width: 60
                            height: 60
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                    }

                    Button {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                        text: "LƯU ẢNH CHỤP MÀN HÌNH"

                        background: Rectangle {
                            color: theme.textMain
                            radius: 8
                        }

                        contentItem: Text {
                            text: parent.text
                            color: "white"
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }
        }
    }
}
