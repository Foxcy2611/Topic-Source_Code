import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

Window {
    id: root
    width: 450; height: 850
    visible: true
    title: "Crypto Wealth Pro"
    color: theme.bg

    // ==========================================
    // 1. DESIGN SYSTEM (QUẢN LÝ MÀU TẬP TRUNG)
    // ==========================================
    QtObject {
        id: theme
        // Backgrounds
        property color bg:          "#0B0E14"
        property color cardBg:      "#151A22"
        property color surface:     "#1E232E"
        property color popupBg:     "#1A202C"
        property color btnDark:     "#2D3748"

        // Texts
        property color textMain:    "#FFFFFF"
        property color textSub:     "#8A92B2"
        property color textDim:     "#555555"
        property color textBit:     "#F7931A"

        // Status & Accents
        property color primary:     "#00F3FF"
        property color profit:      "#00FFA3"
        property color loss:        "#FF4D4D"
        property color bit:         "#33F7931A"

        // Borders & Effects
        property color borderMain:  "#333A4A"
        property color borderInput: "#333333"
        property color overlay:     "#66000000"
        property color shadowGlow:  "#2000F3FF"
        property color profitBg:    "#2000FFA3"
    }

    Item {
        id: appCenter
        anchors.fill: parent

        StackView {
            id: mainstk
            anchors.fill: parent
            initialItem: loginScreen//endScreen//loginScreen

            pushEnter: Transition {
                ParallelAnimation {
                    NumberAnimation {
                        property: "x"
                        from: root.width
                        to: 0
                        duration: 400
                        easing.type: Easing.OutExpo
                    }
                }
            }

            pushExit: Transition {
                ParallelAnimation {
                    NumberAnimation {
                        property: "x"
                        from: 0
                        to: -root.width
                        easing.type: Easing.OutExpo
                    }
                }
            }

            popEnter: Transition {
                ParallelAnimation {
                    NumberAnimation {
                        property: "x"
                        from: -root.width
                        to: 0
                        easing.type: Easing.OutExpo
                    }
                }
            }

            popExit: Transition {
                ParallelAnimation {
                    NumberAnimation {
                        property: "x"
                        from: 0
                        to: root.width
                        easing.type: Easing.OutExpo
                    }
                }
            }
        }
    }

    FastBlur {
        id: ft
        anchors.fill: parent
        source: appCenter
        radius: notifPopup.opened ? 30 : 0

        Behavior on radius {
            NumberAnimation {
                duration: 400
                easing.type: Easing.OutCubic
            }
        }
    }

    Component {
        id: loginScreen

        Rectangle {
            color: theme.bg

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 40
                width: parent.width * 0.8

                Rectangle {
                    width: 100
                    height: 100
                    radius: 100
                    color: "transparent"
                    border.color: theme.primary
                    border.width: 2
                    Layout.alignment: Qt.AlignHCenter

                    Text {
                        text: "₿"
                        anchors.centerIn: parent
                        font.bold: true
                        font.pixelSize: 50
                        color: theme.primary
                        layer.enabled: true
                        layer.effect: Glow {
                            radius: 20
                            color: theme.primary
                            spread: 0.1
                        }
                    }
                }

                Text {
                    text: "WELCOME BACK"
                    font.bold: true
                    font.pixelSize: 28
                    color: "white"
                    Layout.alignment: Qt.AlignHCenter
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 29

                    Rectangle {
                        Layout.fillWidth: true
                        height: 55
                        radius: 15
                        color: theme.cardBg
                        border.color: txtEmail.focus ? theme.primary : theme.borderInput
                        border.width: 2

                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                            }
                        }

                        TextField {
                            id: txtEmail
                            anchors.fill: parent
                            anchors.leftMargin: 20
                            anchors.rightMargin: 20
                            placeholderText: "📧  Email / Username"
                            placeholderTextColor: theme.textSub
                            color: theme.textMain
                            font.pixelSize: 16
                            background: Item {}
                            verticalAlignment: TextInput.AlignVCenter
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 55
                        radius: 15
                        color: theme.cardBg
                        border.color: txtPass.focus ? theme.primary : theme.borderInput
                        border.width: 2

                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                            }
                        }

                        TextField {
                            id: txtPass
                            anchors.fill: parent
                            anchors.leftMargin: 20
                            anchors.rightMargin: 20
                            placeholderText: "🔒  Password"
                            placeholderTextColor: theme.textSub
                            color: theme.textMain
                            font.pixelSize: 16
                            echoMode: TextInput.Password
                            background: Item {}
                            verticalAlignment: TextInput.AlignVCenter
                        }

                        Text {
                            text: txtPass.echoMode === TextInput.Password ? "👁️" : "🙈"
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: 20
                            font.pixelSize: 18
                            color: theme.textSub

                            MouseArea {
                                anchors.fill: parent

                                onClicked: {
                                    txtPass.echoMode = (txtPass.echoMode === TextInput.Password) ? TextInput.Normal : TextInput.Password
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 60
                        radius: 20
                        color: theme.primary

                        Text {
                            text: "SECURE LOGIN"
                            font.bold: true
                            font.pixelSize: 18
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            anchors.fill: parent

                            onPressed: parent.scale = 0.95
                            onReleased: parent.scale = 1.0

                            onClicked: mainstk.push(dashboardScreen)
                        }
                    }
                }
            }
        }
    }

    Component {
        id: dashboardScreen

        Rectangle {
            color: theme.bg

            ListModel {
                id: cryptoModel
                ListElement { name: "Bitcoin"; sym: "BTC"; amount: "0.45"; value: "$28,450.00"; change: "+5.2%"; isUp: true; c: "#F7931A" }
                ListElement { name: "Ethereum"; sym: "ETH"; amount: "4.20"; value: "$8,240.50"; change: "+2.1%"; isUp: true; c: "#627EEA" }
                ListElement { name: "Solana"; sym: "SOL"; amount: "150.0"; value: "$3,150.00"; change: "-1.5%"; isUp: false; c: "#14F195" }
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 30
                spacing: 35

                RowLayout {
                    Layout.fillWidth: true

                    Rectangle {
                        width: 46
                        height: 46
                        radius: 23
                        color: theme.cardBg

                        Text {
                            text: "👤"
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: mainstk.pop()
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Text {
                        text: "ProFile"
                        font.bold: true
                        font.pixelSize: 22
                        color: theme.textMain
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        width: 46
                        height: 46
                        radius: 23
                        color: theme.cardBg

                        Text {
                            text: "🔔"
                            anchors.centerIn: parent
                            font.pixelSize: 20
                        }

                        Rectangle {
                            width: 12
                            height: 12
                            radius: 6
                            color: theme.loss
                            x: 30
                            y: 5
                        }

                        MouseArea {
                            anchors.fill: parent
                            //
                            onClicked: notifPopup.open()
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 220
                    radius: 25

                    gradient: Gradient {
                        GradientStop {
                            position: 0.0
                            color: theme.surface
                        }

                        GradientStop {
                            position: 1.0
                            color: theme.bg
                        }
                    }

                    border.color: theme.borderMain
                    border.width: 1

                    layer.enabled: true
                    layer.effect: DropShadow {
                        radius: 30
                        color: theme.shadowGlow
                        verticalOffset: 10
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 30
                        spacing: 5

                        Text {
                            text: "Total Balance"
                            font.pixelSize: 16
                            color: theme.textSub
                        }

                        Text {
                            text: "$43,790.75"
                            font.bold: true
                            font.pixelSize: 45
                            color: theme.textMain
                        }

                        Rectangle {
                            width: 80
                            height: 30
                            radius: 15
                            color: theme.profitBg

                            Text {
                                text: "▲ +4.2%"
                                anchors.centerIn: parent
                                color: theme.profit
                                font.bold: true
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        Text {
                            text: "**** **** **** 2611"
                            font.bold: true
                            font.pixelSize: 18
                            color: theme.textDim
                            font.letterSpacing: 2
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 20

                    Repeater {
                        model: [
                            { name: "Send", icon: "↗️", c: theme.surface },
                            { name: "Receive", icon: "↙️", c: theme.surface },
                            { name: "Swap", icon: "🔄", c: theme.primary }
                        ]

                        delegate: ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 10

                            Rectangle {
                                id: actionBtn
                                Layout.alignment: Qt.AlignHCenter
                                width: 65
                                height: 65
                                radius: 20
                                color: modelData.c

                                Text {
                                    text: modelData.icon
                                    font.pixelSize: 26
                                    anchors.centerIn: parent
                                    color: index === 2 ? "black" : theme.textMain
                                }

                                MouseArea {
                                    anchors.fill: parent

                                    onPressed: parent.scale = 0.85
                                    onReleased: parent.scale = 1.0

                                    onClicked: {
                                        if(index === 0){
                                            mainstk.push(sendScreen)
                                        } else if(index === 2) {
                                            mainstk.push(swapScreen)
                                        } else if(index === 1){
                                            //
                                        }
                                    }
                                }
                            }

                            Text {
                                text: modelData.name
                                color: theme.textMain
                                font.bold: true
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }
                }

                Text {
                    text: "My Assets"
                    font.bold: true
                    font.pixelSize: 22
                    color: theme.textMain
                }

                ListView {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    model: cryptoModel
                    spacing: 15
                    clip: true

                    delegate: Rectangle {
                        width: ListView.view.width
                        height: 85
                        radius: 15
                        color: theme.cardBg

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 15
                            spacing: 15

                            Rectangle {
                                width: 50
                                height: 50
                                radius: 25
                                border.color: c
                                border.width: 1
                                color: Qt.rgba(c.r, c.g, c.b, 0.2)

                                Text {
                                    text: sym[0]
                                    font.bold: true
                                    font.pixelSize: 22
                                    anchors.centerIn: parent
                                    color: c
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true

                                Text {
                                    text: name
                                    color: theme.textMain
                                    font.bold: true
                                    font.pixelSize: 18
                                }

                                Text {
                                    text: amount + " " + sym
                                    font.pixelSize: 15
                                    color: theme.textSub
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true

                                Text {
                                    text: value
                                    color: theme.textMain
                                    font.bold: true
                                    font.pixelSize: 18
                                    Layout.alignment: Qt.AlignRight
                                }

                                Text {
                                    text: change
                                    color: isUp ? theme.profit : theme.loss
                                    font.pixelSize: 15
                                    font.bold: true
                                    Layout.alignment: Qt.AlignRight
                                }

                            }
                        }
                    }
                }
            }
        }
    }

    // Gui tien
    Component {
        id: sendScreen

        Rectangle{
            color: theme.bg

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 30
                spacing: 30

                RowLayout {
                    Layout.fillWidth: true

                    Rectangle {
                        width: 46
                        height: 46
                        radius: 23
                        color: theme.cardBg

                        Text {
                            text: "❮"
                            font.bold: true
                            font.pixelSize: 20
                            anchors.centerIn: parent
                            color: theme.textMain
                        }

                        MouseArea {
                            anchors.fill: parent

                            onPressed: parent.scale = 0.85
                            onReleased: parent.scale = 1.0

                            onClicked: mainstk.pop()
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Text {
                        text: "Send Crypto"
                        font.bold: true
                        font.pixelSize: 22
                        color: theme.textMain
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Item {
                        width: 45
                        height: 45
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 80
                    radius: 20
                    color: theme.cardBg
                    border.color: theme.borderMain
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 15

                        Rectangle {
                            width: 50
                            height: 50
                            radius: 25
                            color: theme.bit

                            Text {
                                text: "₿"
                                font.bold: true
                                font.pixelSize: 26
                                color: theme.textBit
                                anchors.centerIn: parent
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2

                            Text {
                                text: "Bitcoin"
                                font.bold: true
                                font.pixelSize: 18
                                color: theme.textMain
                            }

                            Text {
                                text: "Balance: 0.45 BTC"
                                font.pixelSize: 14
                                color: theme.textSub
                            }
                        }

                        Text {
                            text: "❯"
                            font.bold: true
                            font.pixelSize: 20
                            color: theme.textSub
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Text {
                        text: "To Address"
                        font.pixelSize: 14
                        color: theme.textSub
                        font.bold: true
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 60
                        radius: 15
                        color: theme.cardBg
                        border.color: txtMoney.focus ? theme.primary : theme.borderInput
                        border.width: 1

                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                            }
                        }

                        TextField {
                            id: txtMoney
                            anchors.fill: parent
                            anchors.leftMargin: 15
                            anchors.rightMargin: 15
                            placeholderText: "Paste or Scan wallet address"
                            placeholderTextColor: theme.textSub
                            color: theme.textMain

                            background: Item {}

                            verticalAlignment: TextInput.AlignVCenter
                        }

                        Text {
                            text: "📷"
                            anchors.right: parent.right
                            anchors.rightMargin: 15
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 20
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    spacing: 15

                    Text {
                        text: "Amount"
                        color: theme.textSub
                        font.pixelSize: 14
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter

                        TextField {
                            id: amountField
                            placeholderText: "0.00"
                            placeholderTextColor: theme.textDim
                            color: theme.primary
                            font.pixelSize: 60
                            font.bold: true
                            font.family: "Arial"

                            background: Item {}

                            horizontalAlignment: TextInput.AlignHCenter
                            validator: DoubleValidator {
                                bottom: 1.0
                                decimals: 6
                                top: 10.0
                                notation: DoubleValidator.StandardNotation
                            } // Chỉ cho nhập số từ 1 -> 10 ; 6 số thập
                        }

                        Text {
                            text: "BTC"
                            color: theme.textMain
                            font.pixelSize: 30
                            font.bold: true
                            Layout.alignment: Qt.AlignBottom
                        }
                    }

                    Text {
                        text: "~ $0.00 USD"
                        color: theme.textSub
                        font.pixelSize: 16
                        Layout.alignment: Qt.AlignHCenter
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10

                        Repeater {
                            model: ["25%", "50%", "MAX"]

                            delegate: Rectangle {
                                width: 70
                                height: 35
                                radius: 18
                                color: theme.surface
                                border.color: theme.borderMain
                                border.width: 1

                                Text {
                                    text: modelData
                                    font.bold: true
                                    color: index === 2 ? theme.primary : theme.textMain
                                    anchors.centerIn: parent
                                }

                                MouseArea {
                                    anchors.fill: parent

                                    onClicked: {
                                        if(index === 0) amountField.text = "2.5"
                                        else if(index === 1) amountField.text = "5"
                                        else if(index === 2) amountField.text = "10"
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 60
                    radius: 30
                    color: amountField.text.length > 0 ? theme.primary : theme.btnDark

                    Behavior on color {
                        ColorAnimation {
                            duration: 300
                        }
                    }

                    Text {
                        text: "CONTINUE"
                        color: amountField.text.length > 0 ? "black" : theme.textSub
                        font.bold: true
                        font.pixelSize: 18
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            if(amountField.text.length > 0){
                                console.log("GUi tien")
                            }
                        }
                    }
                }
            }
        }
    }

    // SWAP

    Component {
        id: swapScreen

        Rectangle {
            color: theme.bg

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 30
                spacing: 20

                RowLayout {
                    Layout.fillWidth: true

                    Rectangle {
                        width: 46
                        height: 46
                        radius: 23
                        color: theme.cardBg

                        Text {
                            text: "❮"
                            color: theme.textMain
                            font.bold: true
                            font.pixelSize: 20
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: mainstk.pop()
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Text {
                        text: "Swap Assets"
                        color: theme.textMain
                        font.bold: true
                        font.pixelSize: 22
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Item {
                        width: 45
                        height: 45
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 100
                    radius: 20
                    color: theme.cardBg

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 15

                        Text {
                            text: "From"
                            font.bold: true
                            font.pixelSize: 14
                            color: theme.textSub
                        }

                        RowLayout {
                            TextField {
                                placeholderText: "0.00"
                                color: theme.textMain
                                placeholderTextColor: theme.textSub

                                background: Item {}
                            }

                            Item {
                                Layout.fillWidth: true
                            }

                            Rectangle {
                                width: 80
                                height: 40
                                radius: 20
                                color: theme.surface

                                Text {
                                    text: "BTC ⌄"
                                    color: "white"
                                    font.bold: true
                                    anchors.centerIn: parent
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    width: 40
                    height: 40
                    radius: 20
                    color: theme.surface
                    border.color: theme.bg
                    border.width: 4
                    z: 2
                    Layout.topMargin: -25
                    Layout.bottomMargin: -25

                    Text {
                        text: "⇅"
                        color: theme.primary
                        font.pixelSize: 20
                        font.bold: true
                        anchors.centerIn: parent
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 100
                    radius: 20
                    color: theme.cardBg

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 15

                        Text {
                            text: "To (Estimated)"
                            color: theme.textSub
                            font.pixelSize: 14
                        }

                        RowLayout {
                            TextField {
                                text: "0.00"
                                color: theme.textMain
                                font.pixelSize: 30
                                font.bold: true
                                readOnly: true
                                background: Item{}
                            }

                            Item {
                                Layout.fillWidth: true
                            }

                            Rectangle {
                                width: 80
                                height: 40
                                radius: 20
                                color: theme.primary

                                Text {
                                    text: "ETH ⌄"
                                    color: "black"
                                    font.bold: true
                                    anchors.centerIn: parent
                                }
                            }
                        }
                    }
                }

                Item {
                    Layout.fillHeight: true
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 60
                    radius: 30
                    color: theme.primary

                    Text {
                        text: "SWAP NOW"
                        color: "black"
                        font.bold: true
                        font.pixelSize: 18
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: console.log("Swapping...")
                    }
                }
            }
        }
    }

    Popup {
        id: notifPopup
        width: parent.width
        height: parent.height * 0.55
        y: parent.height - height
        modal: true
        focus: true
        Overlay.modal: Rectangle {
            color: theme.overlay
        }

        enter: Transition {
            NumberAnimation {
                property: "y"
                from: root.height
                to: root.height - notifPopup.height
                duration: 300
                easing.type: Easing.OutExpo
            }
        }

        exit: Transition {
            NumberAnimation {
                property: "y"
                from: root.height - notifPopup.height
                to: root.height
                duration: 300
                easing.type: Easing.InExpo
            }
        }

        background: Rectangle {
            color: theme.popupBg
            radius: 30

            Rectangle {
                width: parent.width
                height: 30
                anchors.bottom: parent.bottom
                color: theme.popupBg
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 30
            spacing: 20

            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                width: 60
                height: 6
                radius: 3
                color: theme.borderMain
            }

            Text {
                text: "Notifications (3)"
                color: theme.textMain
                font.bold: true
                font.pixelSize: 24
            }

            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 15
                clip: true

                model: [
                    { title: "Deposit Successful", time: "2 mins ago", desc: "Received 0.15 BTC to your wallet.", icon: "✅", c: theme.profit },
                    { title: "Price Alert", time: "1 hour ago", desc: "Ethereum (ETH) is up 5% today!", icon: "🚀", c: theme.primary },
                    { title: "Security Warning", time: "Yesterday", desc: "New login detected from Hanoi, VN.", icon: "⚠️", c: theme.loss }
                ]

                delegate: Rectangle {
                    width: ListView.view.width
                    height: 80
                    radius: 15
                    color: theme.cardBg

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 15

                        Rectangle {
                            width: 50
                            height: 50
                            radius: 25
                            color: Qt.rgba(modelData.c.r, modelData.c.g, modelData.c.b, 0.2)

                            Text {
                                text: modelData.icon
                                font.pixelSize: 20
                                anchors.centerIn: parent
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 3

                            RowLayout {
                                Layout.fillWidth: true
                                Text {
                                    text: modelData.title
                                    color: theme.textMain
                                    font.bold: true
                                    font.pixelSize: 16
                                }

                                Item {
                                    Layout.fillWidth: true
                                }

                                Text {
                                    text: modelData.time
                                    color: theme.textSub
                                    font.pixelSize: 12
                                }
                            }

                            Text {
                                text: modelData.desc
                                color: theme.textSub
                                font.pixelSize: 14
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 50
                radius: 15
                color: theme.btnDark

                Text {
                    text: "Mark all as read"
                    color: theme.textMain
                    font.bold: true
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: notifPopup.close()
                }
            }
        }
    }
}
