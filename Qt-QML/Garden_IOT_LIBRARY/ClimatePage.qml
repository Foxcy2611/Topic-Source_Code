import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    color: "transparent"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 30
        spacing: 30

        Text {
            text: "☀️ KIỂM SOÁT KHÍ HẬU & ÁNH SÁNG"
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
                radius: 10
                color: theme.bgCard
                border.width: 2
                border.color: theme.border

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 30
                    spacing: 30

                    Text {
                        text: "QUẠT GIÓ LÀM MÁT"
                        font.bold: true
                        font.pixelSize: 20
                        color: theme.textMuted
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Rectangle {
                        width: 150
                        height: 150
                        radius: 75
                        color: theme.waterTT
                        Layout.alignment: Qt.AlignHCenter
                        Text {
                            text: "🌀"
                            font.pixelSize: 100
                            anchors.centerIn: parent

                            RotationAnimation on rotation {
                                loops: Animation.Infinite
                                from: 0
                                to: 360
                                duration: 800
                                running: mainWindow.isFanOn
                            }
                        }
                    }

                    Text {
                        text: mainWindow.isFanOn ? "Đang làm mát" : "Đã tắt"
                        font.bold: true
                        font.pixelSize: 22
                        color: mainWindow.isFanOn ? theme.primary : theme.textMuted
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Button {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredHeight: 70
                        Layout.preferredWidth: 200

                        background: Rectangle {
                            color: mainWindow.isFanOn ? theme.textMuted : theme.primary
                            radius: 10
                        }

                        contentItem: Text {
                            color: theme.bgCard
                            text: mainWindow.isFanOn ? "TẮT QUẠT " : "BẬT QUẠT"
                            font.bold: true
                            font.pixelSize: 15
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                        }

                        onClicked: mainWindow.isFanOn = ! mainWindow.isFanOn
                    }
                }
            }

            Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
                radius: 10
                color: theme.bgCard
                border.width: 2
                border.color: theme.border

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 30
                    spacing: 30

                    Text {
                        text: "RÈM CẮT NẮNG TRÊN MÁI"
                        font.bold: true
                        font.pixelSize: 20
                        color: theme.textMuted
                        Layout.alignment: Text.AlignHCenter
                    }

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Độ mở rèm"
                            font.pixelSize: 20
                            color: theme.textMain
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        Text {
                            text: mainWindow.roofOpenLevel + " %"
                            font.bold: true
                            font.pixelSize: 30
                            color: theme.sun
                        }
                    }

                    Slider {
                        Layout.fillWidth: true
                        from: 0
                        to: 100
                        value: roofOpenLevel
                        onValueChanged: roofOpenLevel = value

                        background: Rectangle {
                            x: parent.leftPadding
                            y: parent.topPadding + parent.availableHeight / 2 - height / 2
                            width: parent.availableWidth
                            height: 12
                            color: theme.bgBase
                            radius: 6
                            border.color: theme.border
                            border.width: 1

                            Rectangle {
                                width: parent.parent.visualPosition * parent.width
                                height: parent.height
                                color: theme.sun
                                radius: 6
                            }
                        }
                        handle: Rectangle {
                            x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                            y: parent.topPadding + parent.availableHeight / 2 - height / 2
                            width: 30
                            height: 30
                            radius: 15
                            color: "white"
                            border.color: theme.sun
                            border.width: 4
                        }
                    }

                    Text {
                        text: "Mở rộng càng lớn, lượng ánh sáng mawjtt trời lọt vào càng nhiều. Phù hợp cây ưa sáng"
                        font.pixelSize: 15
                        color: theme.textMuted
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                        Layout.topMargin: 20
                    }

                    Item {
                        Layout.fillHeight: true
                    }
                }
            }
        }
    }
}
