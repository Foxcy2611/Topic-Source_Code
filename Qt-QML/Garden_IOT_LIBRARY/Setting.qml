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
            text: "⚙️ CẤU HÌNH GATEWAY & MẠNG TRẠM"
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
                color: theme.bgCard
                radius: 16
                border.color: theme.border
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 30
                    spacing: 20

                    Text {
                        text: "CẤU HÌNH SERIAL (UART)"
                        font.pixelSize: 18
                        font.bold: true
                        color: theme.textMuted
                    }

                    Rectangle {
                        height: 1
                        Layout.fillWidth: true
                        color: theme.border
                    }

                    RowLayout {

                        Text {
                            text: "Cổng Giao Tiếp:"
                            font.pixelSize: 18
                            color: theme.textMain
                            Layout.preferredWidth: 150
                        }

                        ComboBox {
                            Layout.fillWidth: true
                            model: ["/dev/ttyAMA0 (Pi UART)", "/dev/ttyUSB0", "COM3"] }
                    }

                    RowLayout {

                        Text {
                            text: "Tốc độ (Baudrate):"
                            font.pixelSize: 18
                            color: theme.textMain
                            Layout.preferredWidth: 150
                        }

                        ComboBox {
                            Layout.fillWidth: true
                            model: ["9600", "115200", "921600"]
                            currentIndex: 1
                        }
                    }
                    Item {
                        Layout.fillHeight: true
                    }

                    Button {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                        text: "LƯU CẤU HÌNH KẾT NỐI"

                        background: Rectangle {
                            color: theme.primary
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

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: theme.bgCard
                radius: 16
                border.color: theme.border
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 30
                    spacing: 15

                    Text {
                        text: "TRẠNG THÁI SENSOR NODES"
                        font.pixelSize: 18
                        font.bold: true
                        color: theme.textMuted
                    }

                    Rectangle {
                        height: 1
                        Layout.fillWidth: true
                        color: theme.border
                    }

                    Repeater {
                        model: [
                            { name: "STM32 Node - Khu vực A", status: "Online", ping: "12ms" },
                            { name: "STM32 Node - Khu vực B", status: "Online", ping: "15ms" },
                            { name: "ESP32 Relay Controller", status: "Offline", ping: "--" }
                        ]

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 60
                            color: theme.bgBase
                            radius: 8
                            border.color: theme.border
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 15

                                Rectangle {
                                    width: 12
                                    height: 12
                                    radius: 6
                                    color: modelData.status === "Online" ? theme.primary : theme.danger
                                }

                                Text {
                                    text: modelData.name
                                    font.pixelSize: 16
                                    font.bold: true
                                    color: theme.textMain
                                    Layout.fillWidth: true
                                }

                                Text {
                                    text: modelData.status
                                    font.pixelSize: 14
                                    color: modelData.status === "Online" ? theme.primary : theme.danger
                                }

                                Text {
                                    text: " | Ping: " + modelData.ping
                                    font.pixelSize: 14
                                    color: theme.textMuted
                                }
                            }
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                    }
                }
            }
        }
    }
}
