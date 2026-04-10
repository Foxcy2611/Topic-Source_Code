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
            text: "🌤️ THÔNG TIN THỜI TIẾT KHU VỰC"
            font.pixelSize: 32
            font.bold: true
            color: theme.textMain
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 30

            Rectangle {
                Layout.preferredWidth: 400
                Layout.fillHeight: true
                color: theme.bgCard
                radius: 16
                border.color: theme.border
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 40
                    spacing: 20

                    Text {
                        text: "HÔM NAY"
                        font.pixelSize: 24
                        font.bold: true
                        color: theme.textMuted
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "⛅"
                        font.pixelSize: 120
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "32°C"
                        font.pixelSize: 70
                        font.bold: true
                        color: theme.textMain
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "Trời nắng nhẹ, gió Nam 15km/h"
                        font.pixelSize: 18
                        color: theme.textMuted
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Item {
                        Layout.fillHeight: true
                    }

                    Rectangle {
                        height: 1
                        Layout.fillWidth: true
                        color: theme.border
                    }

                    RowLayout {

                        Text {
                            text: "🌧️ Khả năng mưa:"
                            font.pixelSize: 18
                            color: theme.textMuted
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        Text {
                            text: "10%"
                            font.pixelSize: 20
                            font.bold: true
                            color: theme.water
                        }
                    }

                    RowLayout {

                        Text {
                            text: "🌪️ Cấp gió:"
                            font.pixelSize: 18
                            color: theme.textMuted
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        Text {
                            text: "Cấp 2"
                            font.pixelSize: 20
                            font.bold: true
                            color: theme.primary
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
                    anchors.margins: 40
                    spacing: 30

                    Text {
                        text: "DỰ BÁO 5 NGÀY TỚI"
                        font.pixelSize: 20
                        font.bold: true
                        color: theme.textMuted
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 10

                        Repeater {
                            model: [
                                { day: "Thứ 3", icon: "☀️", temp: "34°C" },
                                { day: "Thứ 4", icon: "⛈️", temp: "28°C" },
                                { day: "Thứ 5", icon: "🌧️", temp: "26°C" },
                                { day: "Thứ 6", icon: "⛅", temp: "30°C" },
                                { day: "Thứ 7", icon: "☀️", temp: "35°C" }
                            ]

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: theme.bgBase
                                radius: 12

                                ColumnLayout {
                                    anchors.centerIn: parent
                                    spacing: 15

                                    Text {
                                        text: modelData.day
                                        font.pixelSize: 18
                                        font.bold: true
                                        color: theme.textMain
                                        Layout.alignment: Qt.AlignHCenter
                                    }

                                    Text {
                                        text: modelData.icon
                                        font.pixelSize: 50
                                        Layout.alignment: Qt.AlignHCenter
                                    }

                                    Text {
                                        text: modelData.temp
                                        font.pixelSize: 22
                                        font.bold: true
                                        color: modelData.icon === "☀️" ? theme.danger : theme.water
                                        Layout.alignment: Qt.AlignHCenter
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
