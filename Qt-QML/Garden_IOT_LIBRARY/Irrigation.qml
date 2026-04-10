import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    color: "transparent"

    ColumnLayout {
        spacing: 30
        anchors.fill: parent
        anchors.margins: 30

        Text {
            text: "💧 HỆ THỐNG THỦY LỢI & TƯỚI TIÊU"
            font.pixelSize: 32
            font.bold: true
            color: theme.textMain
        }

        RowLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 30

            Rectangle {
                Layout.preferredWidth: 350
                Layout.fillHeight: true
                color: theme.bgCard
                radius: 15
                border.width: 2
                border.color: theme.border

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 30
                    spacing: 20

                    Text {
                        text: "BỒN CHỨA NƯỚC DỰ TRỮ"
                        font.bold: true
                        font.pixelSize: 18
                        color: theme.textMuted
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter
                        width: 160
                        height: 350
                        color: theme.waterTT
                        clip: true
                        border.width: 3
                        border.color: theme.border
                        radius: 10

                        Rectangle {
                            width: parent.width
                            height: parent.height * (mainWindow.waterTankLevel / 100.0)
                            color: mainWindow.waterTankLevel > 30 ? theme.water : theme.danger
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            opacity: 0.8
                            radius: 10


                            Behavior on height {
                                NumberAnimation {
                                    duration: 200
                                }
                            }
                        }

                        Column {
                            anchors.fill: parent
                            spacing: parent.height / 5

                            Repeater {
                                model: 5

                                Rectangle {
                                    width: 20
                                    height: 2
                                    color: theme.textMuted
                                }
                            }
                        }
                    }

                    Text {
                        text: mainWindow.waterTankLevel + " %"
                        font.bold: true
                        font.pixelSize: 32
                        color: theme.textMain
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Button {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                        text: "BƠM THÊM NƯỚC VÀO BỒN"

                        background: Rectangle {
                            color: theme.textMain
                            radius: 10
                        }

                        contentItem: Text {
                            text: parent.text
                            color: theme.bgCard
                            font.bold: true
                            font.pixelSize: 18
                        }

                        onClicked: waterTankLevel = 100
                    }
                }
            }

            Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
                radius: 15
                color: theme.bgCard
                border.width: 2
                border.color: theme.border

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 40
                    spacing: 30

                    Text {
                        text: "TRẠNG THÁI BƠM TƯỚI"
                        font.bold: true
                        font.pixelSize: 20
                        color: theme.textMuted
                    }

                    RowLayout {
                        spacing: 20

                        Text {
                            text: mainWindow.isPumpOn ? "💦" : "💧"
                            font.pixelSize: 80
                        }

                        ColumnLayout {
                            spacing: 5

                            Text {
                                text: "Máy bơm khu vực A"
                                font.bold: true
                                font.pixelSize: 24
                                color: theme.textMain
                            }

                            Text {
                                text: mainWindow.isPumpOn ? "Đang tưới cây ..." : "Sẵn sàng"
                                font.pixelSize: 18
                                color: mainWindow.isPumpOn ? theme.water : theme.textMuted
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 2
                        color: theme.border
                    }

                    RowLayout {
                        Text {
                            text: "Độ ẩm hiện tại: "
                            font.pixelSize: 18
                            color: theme.textMuted
                        }

                        Text {
                            text: Math.round(mainWindow.soilMoisture) + " %"
                            color: mainWindow.soilMoisture < 40 ? theme.danger : theme.primary
                            font.bold: true
                            font.pixelSize: 32
                        }
                    }

                    Button {
                        Layout.preferredHeight: 60
                        Layout.preferredWidth: 200
                        enabled: mainWindow.waterTankLevel > 0
                        opacity: mainWindow.waterTankLevel > 0 ? 1 : 0.4
                        background: Rectangle {
                            color: mainWindow.isPumpOn ? theme.danger : theme.water
                            radius: 10
                        }

                        contentItem: Text {
                            text: mainWindow.isPumpOn ? "TẮT MÁY BƠM" : "BẬT MÁY BƠM"
                            font.bold: true
                            font.pixelSize: 15
                            color: theme.bgCard
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                        }

                        onClicked: mainWindow.isPumpOn = !mainWindow.isPumpOn
                    }
                }
            }
        }
    }
}
