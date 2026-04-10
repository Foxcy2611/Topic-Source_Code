// main.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 1280
    height: 720
    title: "SMART GREENHOUSE IOT - COMPONENT BASED"

    // 1. GIỮ NGUYÊN BẢNG MÀU TẠI ĐÂY
    QtObject {
        id: theme
        property color bgBase: "#F0F4F8"
        property color bgCard: "#FFFFFF"
        property color primary: "#10B981"
        property color water: "#3B82F6"
        property color sun: "#F59E0B"
        property color danger: "#EF4444"
        property color textMain: "#1E293B"
        property color textMuted: "#64748B"
        property color border: "#E2E8F0"
        property color pickMenu: "#ECFDF5"
        property color waterTT: "#F1F5F9"
        property color camColor: "#0F172A"
    }

    color: theme.bgBase

    // 2. GIỮ NGUYÊN BIẾN DỮ LIỆU & TIMER
    property real airTemp: 28.5
    property real airHumid: 65.0
    property real soilMoisture: 45.0
    property real lightLux: 5000

    property bool isPumpOn: false
    property int waterTankLevel: 80
    property int roofOpenLevel: 50
    property bool isFanOn: true

    Timer {
        interval: 100
        repeat: true
        running: true
        onTriggered: {
            if (isPumpOn && waterTankLevel > 0) {
                waterTankLevel -= 1;
                if (soilMoisture < 95) soilMoisture += 1.5;
                if (waterTankLevel <= 0) isPumpOn = false;
            } else {
                if (soilMoisture > 30) soilMoisture -= 0.1;
            }
            lightLux = 1000 + (roofOpenLevel * 80) + (Math.random() * 200 - 100);
            if (isFanOn) {
                if (airTemp > 25.0) airTemp -= 0.05;
            } else {
                if (airTemp < 35.0) airTemp += 0.05;
            }
        }
    }

    // 3. LẮP RÁP GIAO DIỆN
    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Gọi component SidebarMenu bạn vừa tạo ở trên
        SidebarMenu {
            Layout.fillHeight: true
            Layout.preferredWidth: 280
            targetStack: mainStk // Truyền StackView vào cho menu điều khiển
        }

        // StackView quản lý các trang
        StackView {
            id: mainStk

            initialItem: "DashboardPage.qml" // Trang mặc định khi bật app
            Layout.fillHeight: true
            Layout.fillWidth: true

            replaceEnter: Transition {
                NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 200 }
            }
            replaceExit: Transition {
                NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 200 }
            }
        }
    }
}
