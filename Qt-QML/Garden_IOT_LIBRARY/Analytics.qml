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
            text: "📈 THỐNG KÊ & PHÂN TÍCH DỮ LIỆU"
            font.pixelSize: 32
            font.bold: true
            color: theme.textMain
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
                spacing: 20

                Text {
                    text: "LƯỢNG NƯỚC TIÊU THỤ 7 NGÀY GẦN NHẤT (Lít)"
                    font.pixelSize: 18
                    font.bold: true
                    color: theme.textMuted
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 40
                    Layout.alignment: Qt.AlignHCenter

                    Repeater {
                        model: [
                            {day: "T2", val: 45},
                            {day: "T3", val: 80},
                            {day: "T4", val: 65},
                            {day: "T5", val: 100},
                            {day: "T6", val: 50},
                            {day: "T7", val: 90},
                            {day: "CN", val: 30}
                        ]

                        ColumnLayout {
                            Layout.fillHeight: true
                            spacing: 10

                            Item {
                                Layout.fillHeight: true
                            }

                            Text {
                                text: modelData.val
                                color: theme.textMain
                                font.bold: true
                                Layout.alignment: Qt.AlignHCenter
                            }

                            Rectangle {
                                width: 40
                                Layout.alignment: Qt.AlignHCenter
                                radius: 6
                                height: modelData.val * 3
                                color: theme.water

                                NumberAnimation on height {
                                    from: 0
                                    to: modelData.val * 3
                                    duration: 800
                                    easing.type: Easing.OutElastic
                                }
                            }

                            Text {
                                text: modelData.day
                                color: theme.textMuted
                                font.bold: true
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }
                }
            }
        }
    }
}
