import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    color: "transparent"

    ColumnLayout {
        anchors.fill: parent
        spacing: 30
        anchors.margins: 30

        Text {
            text: "🌱 TRẠM QUẢN LÝ NHÀ KÍNH"
            font.bold: true
            font.pixelSize: 32
            color: theme.textMain
        }

        GridLayout {
            columns: 2
            rowSpacing: 25
            columnSpacing: 25
            Layout.fillWidth: true

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 140
                color: theme.bgCard
                radius: 16
                border.width: 1
                border.color: theme.border

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 30

                    Text {
                        text: "🌡️"
                        font.pixelSize: 50
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 5

                        Text {
                            text: "Nhiệt độ Không khí"
                            font.bold: true
                            font.pixelSize: 18
                            color: theme.textMuted
                        }

                        Text {
                            text: mainWindow.airTemp.toFixed(1) + " °C"
                            font.bold: true
                            font.pixelSize: 36
                            color: mainWindow.airTemp > 30 ? theme.danger : theme.textMain
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 140
                color: theme.bgCard
                radius: 16
                border.width: 1
                border.color: theme.border

                RowLayout {
                    anchors.fill: parent
                    spacing: 30
                    anchors.margins: 30

                    Text {
                        text: "☁️"
                        font.pixelSize: 50
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 5

                        Text {
                            text: "Độ ẩm Không khí"
                            font.bold: true
                            font.pixelSize: 18
                            color: theme.textMuted
                        }

                        Text {
                            text: mainWindow.airHumid.toFixed(1) + " %"
                            font.bold: true
                            font.pixelSize: 36
                            color: theme.water
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 140
                color: theme.bgCard
                radius: 16
                border.width: 1
                border.color: theme.border

                RowLayout {
                    anchors.fill: parent
                    spacing: 30
                    anchors.margins: 30

                    Text {
                        text: "🟤"
                        font.pixelSize: 50
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 5

                        Text {
                            text: "Độ ẩm Đất (Soil)"
                            font.bold: true
                            font.pixelSize: 18
                            color: theme.textMuted
                        }

                        Text {
                            text: Math.round(mainWindow.soilMoisture) + " %"
                            font.bold: true
                            font.pixelSize: 36
                            color: mainWindow.soilMoisture < 40 ? theme.danger : theme.primary
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 140
                color: theme.bgCard
                radius: 16
                border.width: 1
                border.color: theme.border

                RowLayout {
                    anchors.fill: parent
                    spacing: 30
                    anchors.margins: 30

                    Text {
                        text: "☀️"
                        font.pixelSize: 50
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 5

                        Text {
                            text: "Cường độ Ánh sáng"
                            font.bold: true
                            font.pixelSize: 18
                            color: theme.textMuted
                        }

                        Text {
                            text: Math.round(mainWindow.lightLux) + " Lux"
                            font.bold: true
                            font.pixelSize: 36
                            color: theme.sun
                        }
                    }
                }
            }
        }
    }
}
