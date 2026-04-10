import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtMultimedia 5.15

Window {
    id: root
    width: 1500
    height: 800
    visible: true
    title: "Hệ thống học tập STM32"

    property string linkLogo: "file:///home/chien/Logo/"
    property string linkVideo: "file:///home/chien/Link_Video/"

    property bool isSidebarExpanded: true
    property var activeLesson: null
    property real lastVolume: 1.0

    QtObject {
        id: theme
        readonly property color bg: "#F3F4F6"
        readonly property color surface: "#FFFFFF"
        readonly property color red: "#C92A2A"
        readonly property color yellow: "#D97706"
        readonly property color textMain: "#1F2937"
        readonly property color textSub: "#6B7280"
        readonly property color border: "#E5E7EB"
        readonly property color hover: "#FEF2F2"
        readonly property color activeBg: "#FFFBEB"
        readonly property color logotime: "#00F3FF"
        readonly property color ccpl: "#EEF2FF"
    }

    QtObject {
        id: lg
        property string labb: "LAB"
        property string school: "TRg"
    }

    color: theme.bg

    function formatTime(milliseconds) {
        var minutes = Math.floor(milliseconds / 60000)
        var seconds = Math.floor((milliseconds % 60000) / 1000)
        return (minutes < 10 ? "0" + minutes : minutes) + ":" + (seconds < 10 ? "0" + seconds : seconds)
    }

    function timeToMs(timeString) {
        var parts = timeString.split(":")
        var min = parseInt(parts[0])
        var sec = parseInt(parts[1])
        return (min * 60 + sec) * 1000
    }

    ListModel {
        id: dsbaihoc

        ListElement {
            stt: "1"
            vidName: "24H.mp4"
            name: "Giới thiệu STM32"
            note: "Track: 24H (LyLy)"
        }
        ListElement {
            stt: "2"
            vidName: "AI_NO.mp4"
            name: "GPIO Output"
            note: "Track: Ái Nố (Masew)"
        }
        ListElement {
            stt: "3"
            vidName: "BIGBANG_BLUE.mp4"
            name: "Ngắt EXTI"
            note: "Track: Blue (BigBang)"
        }
        ListElement {
            stt: "4"
            vidName: "BTS_SAVE_ME.mp4"
            name: "Giao tiếp UART"
            note: "Track: Save Me (BTS)"
        }
        ListElement {
            stt: "5"
            vidName: "MO_KHACH_DUONG_XA.mp4"
            name: "Timer Delay"
            note: "Track: Mơ Khách Đường Xa"
        }
        ListElement {
            stt: "6"
            vidName: "NHU_ANH_MO.mp4"
            name: "ADC Convert"
            note: "Track: Như Anh Mơ"
        }
        ListElement {
            stt: "7"
            vidName: "SAU_TAT_CA.mp4"
            name: "Giao tiếp I2C"
            note: "Track: Sau Tất Cả (Erik)"
        }
        ListElement {
            stt: "8"
            vidName: "THUC_GIAC.mp4"
            name: "Giao tiếp SPI"
            note: "Track: Thức Giấc (DaLab)"
        }
        ListElement {
            stt: "9"
            vidName: "vaicaunoicokhiennguoithaydoi.mp4"
            name: "DMA Memory"
            note: "Track: Vài Câu Nói"
        }
    }

    ListModel {
        id: sidebarModel
    }

    property var chapterDatabase: {
        "1": [
            { name: "Mở đầu (Intro)", time: "00:00" },
            { name: "Vào bài (Verse 1)", time: "00:45" },
            { name: "Điệp khúc (Chorus)", time: "01:20" },
            { name: "Kết thúc (Outro)", time: "03:10" }
        ],
        "2": [
            { name: "Intro Ái Nố", time: "00:00" },
            { name: "Đoạn Rap cực cháy", time: "01:05" },
            { name: "Drop nhạc", time: "02:15" }
        ],
        "3": [
            { name: "Giai điệu mở đầu", time: "00:00" },
            { name: "Lời 1 (GD)", time: "00:30" },
            { name: "Lời 2 (TOP)", time: "01:45" },
            { name: "High note (Daesung)", time: "02:50" }
        ]
    }

    function selectLesson(stt, name, note, vidName) {
        var fullPath = linkVideo + vidName
        activeLesson = {
            "stt": stt,
            "name": name,
            "note": note,
            "source": fullPath
        }

        sidebarModel.clear()

        var chapters = chapterDatabase[stt]
        if (chapters) {
            for (var i = 0; i < chapters.length; i++) {
                sidebarModel.append({
                    "name": chapters[i].name,
                    "time": chapters[i].time
                })
            }
        } else {
            sidebarModel.append({
                name: "Bắt đầu video",
                time: "00:00"
            })
            sidebarModel.append({
                name: "(Chưa có dữ liệu Chapter)",
                time: "00:00"
            })
        }
    }

    Component.onCompleted: {
        var item = dsbaihoc.get(0)
        selectLesson(item.stt, item.name, item.note, item.vidName)
    }

    ///////////////////////////////////
    // STACKVIEW CHÍNH
    ///////////////////////////////////
    StackView {
        id: mainstk
        anchors.fill: parent
        initialItem: loginScreen

        pushEnter: Transition {
            NumberAnimation {
                property: "x"
                from: root.width
                to: 0
                duration: 400
                easing.type: Easing.OutExpo
            }
        }
        pushExit: Transition {
            NumberAnimation {
                property: "x"
                from: 0
                to: -root.width
                duration: 400
                easing.type: Easing.OutExpo
            }
        }
        popEnter: Transition {
            NumberAnimation {
                property: "x"
                from: -root.width
                to: 0
                duration: 400
                easing.type: Easing.OutExpo
            }
        }
        popExit: Transition {
            NumberAnimation {
                property: "x"
                from: 0
                to: root.width
                duration: 400
                easing.type: Easing.OutExpo
            }
        }
    }

    /////////////////////////////////////////////////////////////
    // MÀN HÌNH 1: LOGIN
    /////////////////////////////////////////////////////////////
    Component {
        id: loginScreen

        Rectangle {
            color: theme.bg
            clip: true

            Rectangle {
                width: 700
                height: 700
                radius: 350
                x: parent.width - 300
                y: -200
                color: theme.red
                opacity: 0.04
            }

            Rectangle {
                width: 600
                height: 600
                radius: 300
                x: -200
                y: parent.height - 300
                color: theme.yellow
                opacity: 0.1
            }

            Grid {
                x: 80
                y: 80
                opacity: 0.3
                columns: 10
                spacing: 15

                Repeater {
                    model: 80
                    Rectangle {
                        width: 4
                        height: 4
                        radius: 2
                        color: theme.textSub
                    }
                }
            }

            Grid {
                x: parent.width - 250
                y: parent.height - 200
                columns: 12
                spacing: 15
                opacity: 0.3

                Repeater {
                    model: 72
                    Rectangle {
                        width: 4
                        height: 4
                        radius: 2
                        color: theme.textSub
                    }
                }
            }

            Rectangle {
                id: loginCard
                width: 550
                height: 600
                anchors.centerIn: parent
                radius: 20
                color: theme.surface

                ColumnLayout {
                    anchors.fill: parent
                    width: parent.width - 100
                    spacing: 35

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 20

                        Image {
                            Layout.preferredWidth: 150
                            Layout.preferredHeight: 150
                            fillMode: Image.PreserveAspectFit
                            source: linkLogo + lg.school
                        }

                        Image {
                            Layout.preferredWidth: 150
                            Layout.preferredHeight: 150
                            fillMode: Image.PreserveAspectFit
                            source: linkLogo + lg.labb
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Text {
                            text: "HỆ THỐNG HỌC TẬP STM32F103C8"
                            font.bold: true
                            font.pixelSize: 26
                            font.letterSpacing: 1.5
                            color: theme.textMain
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Text {
                            text: "Tiếp tục cho lộ trình của bạn"
                            font.pixelSize: 15
                            color: theme.textSub
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }

                    Rectangle {
                        Layout.preferredHeight: 80
                        Layout.preferredWidth: 200
                        color: theme.border
                        radius: 20
                        Layout.alignment: Qt.AlignHCenter

                        Text {
                            text: "👤 Hi, Ngoc Chien"
                            font.bold: true
                            font.pixelSize: 20
                            anchors.centerIn: parent
                        }
                    }

                    Button {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 60
                        Layout.leftMargin: 40
                        Layout.rightMargin: 40

                        contentItem: Text {
                            text: "VÀO HỌC NGAY"
                            color: "white"
                            font.bold: true
                            font.pixelSize: 18
                            font.letterSpacing: 1.5
                            anchors.centerIn: parent
                        }

                        background: Rectangle {
                            radius: 10
                            color: theme.red
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: mainstk.push(menuScreen)
                        }
                    }
                }
            }

            DropShadow {
                anchors.fill: loginCard
                source: loginCard
                color: "#1A000000"
                radius: 25
                samples: 51
                verticalOffset: 10
            }
        }
    }

    /////////////////////////////////////////////////////////////
    // MÀN HÌNH 2: MENU CHÍNH
    /////////////////////////////////////////////////////////////
    Component {
        id: menuScreen

        Rectangle {
            color: theme.bg
            clip: true

            Rectangle {
                width: 700
                height: 700
                radius: 350
                x: parent.width - 300
                y: -200
                color: theme.red
                opacity: 0.04
            }

            Rectangle {
                width: 600
                height: 600
                radius: 300
                x: -200
                y: parent.height - 300
                color: theme.yellow
                opacity: 0.1
            }

            Grid {
                x: 80
                y: 80
                opacity: 0.3
                columns: 10
                spacing: 15

                Repeater {
                    model: 80
                    Rectangle {
                        width: 4
                        height: 4
                        radius: 2
                        color: theme.textSub
                    }
                }
            }

            Grid {
                x: parent.width - 250
                y: parent.height - 200
                columns: 12
                spacing: 15
                opacity: 0.3

                Repeater {
                    model: 72
                    Rectangle {
                        width: 4
                        height: 4
                        radius: 2
                        color: theme.textSub
                    }
                }
            }

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 50

                ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter

                    Text {
                        text: "CHÀO MỪNG QUAY TRỞ LẠI"
                        color: theme.textMain
                        font.bold: true
                        font.pixelSize: 32
                        font.letterSpacing: 2
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "Chọn chức năng để bắt đầu"
                        color: theme.textSub
                        font.pixelSize: 18
                        Layout.alignment: Qt.AlignHCenter
                    }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 40

                    MenuCard {
                        title: "Bài Giảng Video"
                        iconText: "🎥"
                        desc: "Xem các video hướng dẫn\nlý thuyết và thực hành."
                        cardColor: theme.red
                        onClickedAction: mainstk.push(studyScreen)
                    }

                    MenuCard {
                        title: "Trắc Nghiệm"
                        iconText: "📝"
                        desc: "Luyện trả lời câu hỏi\n về STM32F103C8"
                        cardColor: theme.yellow
                        onClickedAction: mainstk.push(quesScreen)
                    }

                    MenuCard {
                        title: "Giới thiệu"
                        iconText: "ℹ️"
                        desc: "Giới thiệu về chương trình\nvà nhóm phát triển"
                        cardColor: theme.textMain
                        onClickedAction: mainstk.push(revScreen)
                    }
                }

                Button {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 20

                    contentItem: Text {
                        text: "Log Out"
                        color: theme.textSub
                        font.bold: true
                        font.pixelSize: 18
                        font.underline: parent.hovered
                    }

                    background: Rectangle {
                        color: "transparent"
                    }

                    onClicked: mainstk.pop()
                }
            }
        }
    }

    component MenuCard : Rectangle {
        property string title: ""
        property string iconText: ""
        property string desc: ""
        property color cardColor: theme.red
        signal clickedAction()

        width: 320
        height: 380
        radius: 20
        color: theme.surface
        border.color: mouseArea.containsMouse ? cardColor : "transparent"
        border.width: 2
        y: mouseArea.containsMouse ? -10 : 0

        Behavior on y {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 30
            spacing: 20

            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                width: 90
                height: 90
                radius: 45
                color: Qt.lighter(cardColor, 1.8)

                Text {
                    text: iconText
                    font.pixelSize: 40
                    anchors.centerIn: parent
                }
            }

            Text {
                text: title
                font.bold: true
                font.pixelSize: 22
                color: theme.textMain
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: desc
                font.pixelSize: 15
                horizontalAlignment: Text.AlignHCenter
                color: theme.textSub
                Layout.alignment: Qt.AlignHCenter
            }

            Item {
                Layout.fillHeight: true
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                radius: 10
                color: mouseArea.containsMouse ? cardColor : theme.bg

                Text {
                    text: "Bắt đầu ->"
                    font.bold: true
                    color: mouseArea.containsMouse ? "white" : theme.textSub
                    font.pixelSize: 16
                    anchors.centerIn: parent
                }
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: clickedAction()
        }

        DropShadow {
            anchors.fill: parent
            source: parent
            color: "#10000000"
            radius: 20
            samples: 41
            verticalOffset: 8
        }
    }

    /////////////////////////////////////////////////////////////
    // MÀN HÌNH 3: TRẮC NGHIỆM
    /////////////////////////////////////////////////////////////
    Component {
        id: quesScreen

        Rectangle {
            color: theme.bg

            readonly property var quizDatabase: [
                {
                    topicName: "01. Kiến trúc & Toolchain",
                    desc: "Tổng quan về ARM Cortex-M4 và phần mềm lập trình.",
                    questions: [
                        {
                            q: "Dòng STM32F4 hoạt động dựa trên kiến trúc lõi nào?",
                            options: ["Cortex-M0", "Cortex-M3", "Cortex-M4", "Cortex-M7"],
                            correct: 2
                        },
                        {
                            q: "Phần mềm nào hỗ trợ cấu hình mã tự động cho STM32?",
                            options: ["Keil C", "STM32CubeMX", "Proteus", "Altium"],
                            correct: 1
                        }
                    ]
                },
                {
                    topicName: "02. GPIO & Ngắt ngoài",
                    desc: "Điều khiển chân tín hiệu IO và xử lý sự kiện ngắt.",
                    questions: [
                        {
                            q: "Hàm nào dùng để đảo trạng thái một chân GPIO (Toggle) trong thư viện HAL?",
                            options: ["HAL_GPIO_WritePin", "HAL_GPIO_ReadPin", "HAL_GPIO_TogglePin", "HAL_GPIO_Init"],
                            correct: 2
                        },
                        {
                            q: "Ngắt ngoài (EXTI) thường được sử dụng trong trường hợp nào nhất?",
                            options: ["Nháy LED định kỳ", "Đọc trạng thái nút nhấn ngay lập tức", "Truyền dữ liệu máy tính", "Lưu trữ dữ liệu"],
                            correct: 1
                        }
                    ]
                },
                {
                    topicName: "03. Timer & PWM",
                    desc: "Định thời gian và điều chế độ rộng xung.",
                    questions: [
                        {
                            q: "Ứng dụng phổ biến nhất của PWM là gì?",
                            options: ["Đọc nhiệt độ", "Điều chỉnh độ sáng LED/Tốc độ động cơ", "Giao tiếp máy tính", "Lưu dữ liệu vào thẻ nhớ"],
                            correct: 1
                        }
                    ]
                },
                {
                    topicName: "04. Giao tiếp UART",
                    desc: "Chuẩn giao tiếp nối tiếp bất đồng bộ.",
                    questions: [
                        {
                            q: "Thông số Baudrate trong UART dùng để chỉ điều gì?",
                            options: ["Điện áp truyền tải", "Tốc độ truyền (bit/giây)", "Độ dài khung truyền", "Chế độ chẵn lẻ"],
                            correct: 1
                        }
                    ]
                }
            ]

            property int currentTopicIdx: 0
            property int currentIndex: 0
            property int score: 0
            property bool isAnswered: false
            property int selectedIdx: -1

            function startQuiz() {
                currentIndex = 0
                score = 0
                isAnswered = false
                selectedIdx = -1
                quizstk.push(questionScreen)
            }

            function checkAnswer(idx) {
                if (isAnswered) return
                selectedIdx = idx
                isAnswered = true
                if (idx === quizDatabase[currentTopicIdx].questions[currentIndex].correct) {
                    score++
                }
            }

            function nextQuestion() {
                if (currentIndex < quizDatabase[currentTopicIdx].questions.length - 1) {
                    currentIndex++
                    isAnswered = false
                    selectedIdx = -1
                } else {
                    quizstk.push(resultScreen)
                }
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 20

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 70
                    color: theme.surface
                    radius: 15

                    layer.enabled: true
                    layer.effect: DropShadow {
                        radius: 15
                        samples: 31
                        color: "#10000000"
                        verticalOffset: 5
                    }

                    ListView {
                        anchors.fill: parent
                        orientation: ListView.Horizontal
                        clip: true
                        spacing: 5
                        model: quizDatabase

                        header: Item { width: 10 }
                        footer: Item { width: 10 }

                        delegate: Rectangle {
                            width: 240
                            height: ListView.view.height
                            color: "transparent"

                            Rectangle {
                                width: parent.width - 20
                                height: 5
                                color: theme.red
                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter: parent.horizontalCenter
                                radius: 5
                                visible: currentTopicIdx === index
                            }

                            Text {
                                text: modelData.topicName
                                font.bold: true
                                color: (currentTopicIdx === index) ? theme.red : theme.textSub
                                anchors.centerIn: parent
                                font.pixelSize: 16
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if(currentTopicIdx !== index) {
                                        currentTopicIdx = index
                                        quizstk.pop(null)
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    color: "transparent"

                    StackView {
                        id: quizstk
                        anchors.fill: parent
                        initialItem: introScreen

                        pushEnter: Transition {
                            PropertyAnimation {
                                property: "opacity"
                                from: 0
                                to: 1
                                duration: 200
                            }
                        }
                        pushExit: Transition {
                            PropertyAnimation {
                                property: "opacity"
                                from: 1
                                to: 0
                                duration: 200
                            }
                        }
                        popEnter: Transition {
                            PropertyAnimation {
                                property: "opacity"
                                from: 0
                                to: 1
                                duration: 200
                            }
                        }
                        popExit: Transition {
                            PropertyAnimation {
                                property: "opacity"
                                from: 1
                                to: 0
                                duration: 200
                            }
                        }
                    }
                }
            }

            Component {
                id: introScreen

                Rectangle {
                    color: "transparent"

                    ColumnLayout {
                        anchors.centerIn: parent
                        width: 650
                        spacing: 30

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 300
                            color: theme.surface
                            radius: 20

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 40
                                spacing: 15

                                Rectangle {
                                    Layout.alignment: Qt.AlignHCenter
                                    width: 80
                                    height: 80
                                    radius: 40
                                    color: theme.hover

                                    Text {
                                        text: "📝"
                                        font.pixelSize: 40
                                        anchors.centerIn: parent
                                    }
                                }

                                Text {
                                    text: quizDatabase[currentTopicIdx].topicName
                                    font.bold: true
                                    font.pixelSize: 28
                                    color: theme.red
                                    Layout.alignment: Qt.AlignHCenter
                                }

                                Text {
                                    text: quizDatabase[currentTopicIdx].desc
                                    font.pixelSize: 16
                                    color: theme.textSub
                                    horizontalAlignment: Text.AlignHCenter
                                    wrapMode: Text.WordWrap
                                    Layout.fillWidth: true
                                }

                                Rectangle {
                                    Layout.fillWidth: true
                                    height: 1
                                    color: theme.border
                                    Layout.topMargin: 10
                                    Layout.bottomMargin: 10
                                }

                                RowLayout {
                                    Layout.alignment: Qt.AlignHCenter
                                    spacing: 20

                                    Text {
                                        text: "Số lượng câu hỏi: "
                                        color: theme.textMain
                                        font.pixelSize: 16
                                    }

                                    Text {
                                        text: quizDatabase[currentTopicIdx].questions.length + " Câu"
                                        color: theme.red
                                        font.bold: true
                                        font.pixelSize: 18
                                    }
                                }
                            }

                            layer.enabled: true
                            layer.effect: DropShadow {
                                radius: 20
                                samples: 41
                                color: "#10000000"
                                verticalOffset: 8
                            }
                        }

                        RowLayout {
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 20

                            Button {
                                Layout.preferredWidth: 200
                                Layout.preferredHeight: 60

                                background: Rectangle {
                                    color: theme.surface
                                    border.color: theme.border
                                    border.width: 2
                                    radius: 10
                                }

                                contentItem: Text {
                                    text: "← TRỞ VỀ MENU"
                                    color: theme.textMain
                                    font.bold: true
                                    font.pixelSize: 15
                                    anchors.centerIn: parent
                                }

                                onClicked: mainstk.pop()
                            }

                            Button {
                                Layout.preferredWidth: 250
                                Layout.preferredHeight: 60

                                background: Rectangle {
                                    color: theme.red
                                    radius: 10
                                }

                                contentItem: Text {
                                    text: "BẮT ĐẦU LÀM BÀI ▶"
                                    color: "white"
                                    font.bold: true
                                    font.pixelSize: 15
                                    anchors.centerIn: parent
                                }

                                onClicked: startQuiz()
                            }
                        }
                    }
                }
            }

            Component {
                id: questionScreen

                Rectangle {
                    color: "transparent"

                    ColumnLayout {
                        anchors.centerIn: parent
                        width: 900
                        spacing: 30

                        RowLayout {
                            Layout.fillWidth: true

                            Text {
                                text: "Đang làm: " + quizDatabase[currentTopicIdx].topicName
                                color: theme.textSub
                                font.pixelSize: 16
                                font.italic: true
                            }

                            Item {
                                Layout.fillWidth: true
                            }

                            Text {
                                text: "Điểm: " + score
                                color: theme.textMain
                                font.bold: true
                                font.pixelSize: 18
                            }

                            Text {
                                text: " |  Câu: " + (currentIndex + 1) + "/" + quizDatabase[currentTopicIdx].questions.length
                                font.bold: true
                                color: theme.red
                                font.pixelSize: 18
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 180
                            color: theme.surface
                            radius: 20

                            layer.enabled: true
                            layer.effect: DropShadow {
                                radius: 15
                                samples: 31
                                color: "#10000000"
                                verticalOffset: 5
                            }

                            Text {
                                anchors.centerIn: parent
                                width: parent.width - 80
                                text: quizDatabase[currentTopicIdx].questions[currentIndex].q
                                font.bold: true
                                font.pixelSize: 22
                                color: theme.textMain
                                wrapMode: Text.WordWrap
                                horizontalAlignment: Text.AlignHCenter
                                lineHeight: 1.3
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 15

                            Repeater {
                                model: quizDatabase[currentTopicIdx].questions[currentIndex].options

                                delegate: Button {
                                    id: optBtn
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 65

                                    property bool isCorrect: index === quizDatabase[currentTopicIdx].questions[currentIndex].correct
                                    property bool isWrong: isAnswered && index === selectedIdx && index !== quizDatabase[currentTopicIdx].questions[currentIndex].correct

                                    background: Rectangle {
                                        radius: 12
                                        color: isAnswered ? (isCorrect ? "#D1FAE5" : (isWrong ? "#FEE2E2" : theme.surface)) : (optBtn.hovered ? theme.activeBg : theme.surface)
                                        border.color: isAnswered ? (isCorrect ? "#059669" : (isWrong ? theme.red : theme.border)) : (optBtn.hovered ? theme.yellow : theme.border)
                                        border.width: (optBtn.hovered || isAnswered) ? 2 : 1
                                    }

                                    contentItem: RowLayout {
                                        anchors.fill: parent
                                        anchors.leftMargin: 25
                                        anchors.rightMargin: 25

                                        Text {
                                            text: String.fromCharCode(65 + index) + ".  " + modelData
                                            color: isAnswered ? (isCorrect ? "#059669" : (isWrong ? theme.red : theme.textMain)) : theme.textMain
                                            font.bold: true
                                            font.pixelSize: 18
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                        }

                                        Text {
                                            visible: isAnswered && (isCorrect || isWrong)
                                            text: isCorrect ? "✔" : "✘"
                                            color: isCorrect ? "#059669" : theme.red
                                            font.bold: true
                                            font.pixelSize: 22
                                        }
                                    }
                                    onClicked: checkAnswer(index)
                                }
                            }
                        }

                        Button {
                            Layout.alignment: Qt.AlignRight
                            Layout.preferredWidth: 200
                            Layout.preferredHeight: 55
                            visible: isAnswered

                            background: Rectangle {
                                color: theme.red
                                radius: 10
                            }

                            contentItem: Text {
                                text: (currentIndex < quizDatabase[currentTopicIdx].questions.length - 1) ? "CÂU TIẾP THEO →" : "XEM KẾT QUẢ"
                                color: "white"
                                font.bold: true
                                font.pixelSize: 15
                                anchors.centerIn: parent
                            }

                            onClicked: nextQuestion()
                        }
                    }
                }
            }

            Component {
                id: resultScreen

                Rectangle {
                    color: "transparent"

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 30

                        Rectangle {
                            width: 500
                            height: 350
                            color: theme.surface
                            radius: 25

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 20

                                Text {
                                    text: "🏆"
                                    font.pixelSize: 80
                                    Layout.alignment: Qt.AlignHCenter
                                }

                                Text {
                                    text: "ĐIỂM SỐ CỦA BẠN"
                                    font.bold: true
                                    font.pixelSize: 22
                                    color: theme.textMain
                                    Layout.alignment: Qt.AlignHCenter
                                }

                                Rectangle {
                                    Layout.preferredWidth: 300
                                    Layout.preferredHeight: 100
                                    radius: 20
                                    color: theme.bg

                                    ColumnLayout {
                                        anchors.centerIn: parent
                                        spacing: 5

                                        Text {
                                            text: "Chủ đề: " + quizDatabase[currentTopicIdx].topicName
                                            color: theme.textSub
                                            font.pixelSize: 14
                                            Layout.alignment: Qt.AlignHCenter
                                        }

                                        Text {
                                            text: score + " / " + quizDatabase[currentTopicIdx].questions.length
                                            font.bold: true
                                            font.pixelSize: 42
                                            color: theme.red
                                            Layout.alignment: Qt.AlignHCenter
                                        }
                                    }
                                }
                            }

                            layer.enabled: true
                            layer.effect: DropShadow {
                                radius: 20
                                samples: 41
                                color: "#10000000"
                                verticalOffset: 10
                            }
                        }

                        RowLayout {
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 20

                            Button {
                                Layout.preferredWidth: 200
                                Layout.preferredHeight: 55

                                background: Rectangle {
                                    color: theme.surface
                                    radius: 10
                                    border.color: theme.border
                                    border.width: 2
                                }

                                contentItem: Text {
                                    text: "↺ LÀM LẠI BÀI NÀY"
                                    font.bold: true
                                    color: theme.textMain
                                    anchors.centerIn: parent
                                }

                                onClicked: startQuiz()
                            }

                            Button {
                                Layout.preferredWidth: 200
                                Layout.preferredHeight: 55

                                background: Rectangle {
                                    color: theme.red
                                    radius: 10
                                }

                                contentItem: Text {
                                    text: "CHỌN MÔN KHÁC"
                                    font.bold: true
                                    color: "white"
                                    anchors.centerIn: parent
                                }

                                onClicked: quizstk.pop(null)
                            }
                        }
                    }
                }
            }
        }
    }

    /////////////////////////////////////////////////////////////
    // MÀN HÌNH 4: THÔNG TIN HỆ THỐNG (ABOUT PAGE)
    /////////////////////////////////////////////////////////////
    Component {
        id: revScreen

        Rectangle {
            color: theme.bg

            ColumnLayout {
                anchors.centerIn: parent
                width: 1000
                spacing: 40

                ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 5

                    Text {
                        text: "THÔNG TIN HỆ THỐNG"
                        font.bold: true
                        font.pixelSize: 28
                        font.letterSpacing: 1.2
                        color: theme.red
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "Phiên bản 1.0.0"
                        font.pixelSize: 16
                        color: theme.textSub
                        Layout.alignment: Qt.AlignHCenter
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 40

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 380
                        color: theme.surface
                        radius: 20

                        layer.enabled: true
                        layer.effect: DropShadow {
                            radius: 20
                            samples: 41
                            color: "#10000000"
                            verticalOffset: 8
                        }

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 40
                            spacing: 15

                            Rectangle {
                                width: 135
                                height: 80
                                radius: 20
                                color: theme.red

                                Text {
                                    text: "STM32F103"
                                    font.bold: true
                                    font.pixelSize: 22
                                    color: "white"
                                    anchors.centerIn: parent
                                }
                            }

                            Text {
                                text: "Hệ thống Học tập STM32F103"
                                font.bold: true
                                font.pixelSize: 25
                                color: theme.textMain
                            }

                            Text {
                                text: "Đây là phần mềm hỗ trợ học sinh/sinh viên học tập và thực hành lập trình vi điều khiển thuộc dòng Cortex-M. Hệ thống tích hợp trình phát video chất lượng, kết hợp kiểm tra tổng ôn kiến thức sau khi kết thúc bài học"
                                font.pixelSize: 16
                                color: theme.textSub
                                lineHeight: 1.5
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }

                            Item {
                                Layout.fillWidth: true
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 2
                                color: theme.textSub
                            }

                            Text {
                                text: "Công nghệ sử dụng: "
                                font.bold: true
                                font.pixelSize: 12
                                color: theme.textSub
                                Layout.topMargin: 10
                            }

                            RowLayout {
                                spacing: 15

                                Rectangle {
                                    width: 90
                                    height: 30
                                    radius: 15
                                    color: theme.activeBg

                                    Text {
                                        text: "C/C++"
                                        font.bold: true
                                        color: theme.red
                                        anchors.centerIn: parent
                                    }
                                }

                                Rectangle {
                                    width: 90
                                    height: 30
                                    radius: 15
                                    color: theme.logotime

                                    Text {
                                        text: "Embedded"
                                        font.bold: true
                                        color: "white"
                                        anchors.centerIn: parent
                                    }
                                }

                                Rectangle {
                                    width: 90
                                    height: 30
                                    radius: 15
                                    color: theme.ccpl

                                    Text {
                                        text: "Qt/QML"
                                        font.bold: true
                                        color: theme.textMain
                                        anchors.centerIn: parent
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.preferredHeight: 380
                        Layout.preferredWidth: 400
                        color: theme.surface
                        radius: 20

                        layer.enabled: true
                        layer.effect: DropShadow {
                            radius: 20
                            samples: 41
                            color: "#10000000"
                            verticalOffset: 8
                        }

                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 15
                            anchors.margins: 20

                            Rectangle {
                                Layout.alignment: Qt.AlignHCenter
                                width: 100
                                radius: 50
                                height: 100
                                color: theme.hover
                                border.color: theme.red
                                border.width: 4

                                Text {
                                    text: "DEV"
                                    font.bold: true
                                    font.pixelSize: 26
                                    anchors.centerIn: parent
                                    color: theme.red
                                }
                            }

                            ColumnLayout {
                                Layout.alignment: Qt.AlignHCenter
                                spacing: 15

                                Text {
                                    text: "Phát triển bởi"
                                    font.pixelSize: 14
                                    color: theme.textSub
                                    Layout.alignment: Qt.AlignHCenter
                                }

                                Text {
                                    text: "Nhóm Sinh Viên"
                                    font.bold: true
                                    font.pixelSize: 22
                                    color: theme.textMain
                                    Layout.alignment: Qt.AlignHCenter
                                }

                                Text {
                                    text: "Khoa Điện tử Viễn Thông"
                                    font.bold: true
                                    font.pixelSize: 15
                                    color: theme.yellow
                                    Layout.alignment: Qt.AlignHCenter
                                }
                            }

                            Item {
                                Layout.fillWidth: true
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 2
                                color: theme.textSub
                            }

                            ColumnLayout {
                                spacing: 15
                                Layout.fillWidth: true
                                Layout.topMargin: 10

                                RowLayout {
                                    spacing: 15

                                    Rectangle {
                                        width: 35
                                        height: 35
                                        color: theme.bg
                                        radius: 8

                                        Text {
                                            text: "@"
                                            font.bold: true
                                            color: theme.textSub
                                            anchors.centerIn: parent
                                        }
                                    }

                                    Text {
                                        text: "ChienNN.B23VT061@stu.ptit.edu.vn"
                                        font.pixelSize: 15
                                        color: theme.textSub
                                    }
                                }

                                RowLayout {
                                    spacing: 15

                                    Rectangle {
                                        width: 35
                                        height: 35
                                        color: theme.bg
                                        radius: 8

                                        Text {
                                            text: "</>"
                                            font.bold: true
                                            color: theme.textSub
                                            anchors.centerIn: parent
                                        }
                                    }

                                    Text {
                                        text: "github.com/project-stm32f103"
                                        font.pixelSize: 15
                                        color: theme.textSub
                                    }
                                }
                            }
                        }
                    }
                }

                Button {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredHeight: 70
                    Layout.preferredWidth: 250
                    Layout.topMargin: 20

                    background: Rectangle {
                        color: theme.surface
                        border.color: theme.border
                        border.width: 3
                        radius: 10
                    }

                    contentItem: Text {
                        text: "TRỞ VỀ MENU"
                        font.bold: true
                        font.pixelSize: 20
                        anchors.centerIn: parent
                        color: theme.textMain
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onEntered: parent.background.color = theme.hover
                        onExited: parent.background.color = theme.surface
                        onClicked: mainstk.pop()
                    }
                }
            }
        }
    }

    /////////////////////////////////////////////////////////////
    // MÀN HÌNH 5: VIDEO PLAYER
    /////////////////////////////////////////////////////////////
    Component {
        id: studyScreen

        Rectangle {
            color: "transparent"

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 65
                    color: theme.surface

                    Button {
                        Layout.preferredHeight: 50
                        Layout.preferredWidth: 200
                        Layout.leftMargin: 10
                        Layout.topMargin: 20

                        background: Rectangle {
                            color: "transparent"
                            border.color: theme.border
                            border.width: 2
                        }

                        contentItem: Text {
                            text: "Quay lại Menu"
                            color: theme.textSub
                            font.bold: true
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onEntered: parent.background.color = theme.hover
                            onExited: parent.background.color = theme.surface
                            onClicked: {
                                videoPlayer.pause()
                                mainstk.pop()
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 3
                        color: theme.red
                        anchors.bottom: parent.bottom
                    }

                    Text {
                        text: activeLesson ? "ĐANG PHÁT: " + activeLesson.note : ""
                        font.bold: true
                        color: theme.red
                        font.pixelSize: 18
                        anchors.centerIn: parent
                        font.letterSpacing: 1.2
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 0

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "black"

                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 0

                            Video {
                                id: videoPlayer
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                source: activeLesson ? activeLesson.source : ""
                                autoPlay: true
                                volume: 0.5

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: videoPlayer.playbackState === MediaPlayer.PlayingState ? videoPlayer.pause() : videoPlayer.play()
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 65
                                color: theme.surface

                                Rectangle {
                                    width: parent.width
                                    height: 1
                                    color: theme.border
                                    anchors.top: parent.top
                                }

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 15
                                    spacing: 15

                                    Text {
                                        text: videoPlayer.playbackState === MediaPlayer.PlayingState ? "⏸" : "▶"
                                        color: theme.red
                                        font.pixelSize: 28

                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: videoPlayer.playbackState === MediaPlayer.PlayingState ? videoPlayer.pause() : videoPlayer.play()
                                        }
                                    }

                                    Text {
                                        text: formatTime(videoPlayer.position)
                                        color: theme.textMain
                                        font.bold: true
                                        font.pixelSize: 14
                                    }

                                    Slider {
                                        id: seekSlider
                                        Layout.fillWidth: true
                                        from: 0
                                        to: videoPlayer.duration
                                        value: videoPlayer.position
                                        onMoved: videoPlayer.seek(value)

                                        background: Rectangle {
                                            x: seekSlider.leftPadding
                                            y: seekSlider.topPadding + seekSlider.availableHeight / 2 - height / 2
                                            width: seekSlider.availableWidth
                                            height: 6
                                            radius: 3
                                            color: theme.border

                                            Rectangle {
                                                width: seekSlider.visualPosition * parent.width
                                                height: parent.height
                                                color: theme.red
                                                radius: 3
                                            }
                                        }

                                        handle: Rectangle {
                                            x: seekSlider.leftPadding + seekSlider.visualPosition * (seekSlider.availableWidth - width)
                                            y: seekSlider.topPadding + seekSlider.availableHeight / 2 - height / 2
                                            width: 16
                                            height: 16
                                            radius: 8
                                            color: theme.red
                                            border.color: "white"
                                            border.width: 2
                                        }
                                    }

                                    Text {
                                        text: formatTime(videoPlayer.duration)
                                        color: theme.textSub
                                        font.pixelSize: 14
                                    }

                                    RowLayout {
                                        spacing: 8

                                        Text {
                                            text: videoPlayer.volume > 0 ? "🔊" : "🔇"
                                            color: theme.textMain
                                            font.pixelSize: 20

                                            MouseArea {
                                                anchors.fill: parent
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    if (videoPlayer.volume > 0) {
                                                        lastVolume = videoPlayer.volume
                                                        videoPlayer.volume = 0
                                                    } else {
                                                        videoPlayer.volume = lastVolume
                                                    }
                                                }
                                            }
                                        }

                                        Slider {
                                            id: volumeSlider
                                            Layout.preferredWidth: 100
                                            from: 0.0
                                            to: 1.0
                                            value: videoPlayer.volume
                                            onMoved: videoPlayer.volume = value

                                            background: Rectangle {
                                                x: volumeSlider.leftPadding
                                                y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                                                width: volumeSlider.availableWidth
                                                height: 6
                                                radius: 3
                                                color: theme.border

                                                Rectangle {
                                                    width: volumeSlider.visualPosition * parent.width
                                                    height: parent.height
                                                    color: theme.yellow
                                                    radius: 3
                                                }
                                            }

                                            handle: Rectangle {
                                                x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
                                                y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                                                width: 14
                                                height: 14
                                                radius: 7
                                                color: theme.yellow
                                                border.color: "white"
                                                border.width: 2
                                            }
                                        }
                                    }

                                    Text {
                                        text: "☰"
                                        color: isSidebarExpanded ? theme.red : theme.textSub
                                        font.pixelSize: 26
                                        font.bold: true

                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: isSidebarExpanded = !isSidebarExpanded
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: isSidebarExpanded ? 300 : 0
                        Layout.fillHeight: true
                        color: theme.surface
                        clip: true

                        Rectangle {
                            width: 1
                            height: parent.height
                            color: theme.border
                            anchors.left: parent.left
                        }

                        Behavior on Layout.preferredWidth {
                            NumberAnimation {
                                duration: 300
                                easing.type: Easing.OutCubic
                            }
                        }

                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 0

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 65
                                color: theme.bg

                                Rectangle {
                                    width: parent.width
                                    height: 1
                                    color: theme.border
                                    anchors.bottom: parent.bottom
                                }

                                Text {
                                    text: "CHAPTERS"
                                    anchors.centerIn: parent
                                    font.bold: true
                                    color: theme.textMain
                                    font.letterSpacing: 1.5
                                }
                            }

                            ListView {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                model: sidebarModel
                                clip: true

                                delegate: Rectangle {
                                    width: ListView.view.width
                                    height: 60
                                    color: "transparent"

                                    Rectangle {
                                        width: parent.width - 20
                                        height: 1
                                        color: theme.border
                                        anchors.bottom: parent.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }

                                    Rectangle {
                                        anchors.fill: parent
                                        color: mouseInStep.containsMouse ? theme.hover : "transparent"
                                    }

                                    Text {
                                        text: name
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.left: parent.left
                                        anchors.leftMargin: 20
                                        color: theme.textMain
                                        font.pixelSize: 14
                                    }

                                    Text {
                                        text: time
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.right: parent.right
                                        anchors.rightMargin: 20
                                        color: theme.red
                                        font.bold: true
                                        font.pixelSize: 13
                                    }

                                    MouseArea {
                                        id: mouseInStep
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            videoPlayer.seek(timeToMs(time))
                                            videoPlayer.play()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 180
                    color: theme.bg

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: theme.border
                        anchors.top: parent.top
                    }

                    ListView {
                        anchors.fill: parent
                        anchors.margins: 15
                        orientation: ListView.Horizontal
                        spacing: 15
                        model: dsbaihoc
                        clip: true

                        delegate: Rectangle {
                            height: ListView.view.height
                            width: 240
                            radius: 10
                            color: (activeLesson && activeLesson.stt === stt) ? theme.activeBg : theme.surface
                            border.color: (activeLesson && activeLesson.stt === stt) ? theme.yellow : theme.border
                            border.width: (activeLesson && activeLesson.stt === stt) ? 2 : 1

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 15
                                spacing: 5

                                Text {
                                    text: "BÀI " + stt
                                    font.bold: true
                                    font.pixelSize: 12
                                    font.letterSpacing: 1
                                    color: (activeLesson && activeLesson.stt === stt) ? theme.yellow : theme.red
                                }

                                Text {
                                    text: name
                                    Layout.fillWidth: true
                                    wrapMode: Text.WordWrap
                                    font.pixelSize: 15
                                    font.bold: true
                                    color: theme.textMain
                                }

                                Item {
                                    Layout.fillHeight: true
                                }

                                Text {
                                    text: "🎵 " + note
                                    color: theme.textSub
                                    font.italic: true
                                    Layout.fillWidth: true
                                    wrapMode: Text.WordWrap
                                    font.pixelSize: 13
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: selectLesson(stt, name, note, vidName)
                            }
                        }
                    }
                }
            }
        }
    }
}
