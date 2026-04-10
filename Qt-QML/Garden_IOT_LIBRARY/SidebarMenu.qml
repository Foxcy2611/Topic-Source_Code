// SidebarMenu.qml
import QtQuick 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    border.width: 1
    border.color: theme.border
    color: theme.bgCard

    // API để nhận StackView từ main.qml truyền vào
    property var targetStack: null

    ColumnLayout {
        id: menuLayout
        anchors.fill: parent
        spacing: 0

        property int selectIndex: 0

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            color: "transparent"

            RowLayout {
                anchors.centerIn: parent
                spacing: 10

                Text {
                    text: "🌿"; font.pixelSize: 40
                }

                ColumnLayout {
                    spacing: 0
                    Text {
                        text: "Agri-IoT"
                        font.pixelSize: 24
                        font.bold: true
                        color: theme.primary
                    }

                    Text {
                        text: "Hệ thống thông minh"
                        font.pixelSize: 18
                        color: theme.textMuted
                    }
                }
            }
        }

        Rectangle {
            height: 1
            Layout.fillWidth: true
            color: theme.border
        }

        Repeater {

            model: [
               { name: "Tổng quan", icon: "📊", comp: "DashboardPage.qml" },
               { name: "Tưới tiêu & Bơm", icon: "💧", comp: "IrrigationPage.qml" },
               { name: "Khí hậu & Ánh sáng", icon: "☀️", comp: "ClimatePage.qml" },
               { name: "Thống kê dữ liệu", icon: "📈", comp: "AnalyticsPage.qml" },
               { name: "Dự báo thời tiết", icon: "🌤️", comp: "WeatherPage.qml" },
               { name: "Camera Giám sát", icon: "📷", comp: "CameraPage.qml" },
               { name: "Cấu hình Hệ thống", icon: "⚙️", comp: "SettingsPage.qml" }
           ]

            Rectangle {
                id: itemMenu
                Layout.fillWidth: true
                Layout.preferredHeight: 70

                property bool isActive: index === menuLayout.selectIndex

                color: itemMenu.isActive ? theme.pickMenu : "transparent"

                Rectangle {
                    width: 4
                    height: parent.height
                    color: theme.primary
                    visible: itemMenu.isActive
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 25
                    spacing: 20

                    Text {
                        text: modelData.icon
                        font.pixelSize: 22
                    }

                    Text {
                        text: modelData.name
                        font.pixelSize: 18
                        font.bold: itemMenu.isActive
                        color: itemMenu.isActive ? theme.primary : theme.textMain
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        menuLayout.selectIndex = index
                        // Nạp file QML mới vào StackView
                        if(root.targetStack && root.targetStack.currentItem !== modelData.comp) {
                            root.targetStack.replace(modelData.comp)
                        }
                    }
                }
            }
        }
        Item { Layout.fillHeight: true }
    }
}
