import QtQuick 2.2
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2

Item {
    id: rootItem
    property int rootItemWidth:1366
    property int rootItemHeight:724

    property bool demoMode: true
    property alias username: name_text_field.text
    property int gameMode: 0 // 0 -> pistol, 1 -> rifel
    property int gameEvent: 0
    property int papermode: 0

    MessageDialog
    {
        id: invalidUserName
        title: "Warning"
        text: "Please enter user name to login"
        visible: false
    }


    Rectangle {
        id: fullRect
        color: "#202020"
        anchors.fill: parent
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            gameEventList.visible = false
            papermodeList.visible = false
        }
    }

    Rectangle {
        id: bgRect
        width: bg.paintedWidth
        height: bg.paintedHeight
        color: "transparent"
        anchors.centerIn: parent
    }

    function validate()
    {
        if(username === "")
        {
            console.log("I am here ..........")
            invalidUserName.visible = true
            return false
        }

        if (username === "" || !demoMode)
            return false

        return true
    }

    function reset()
    {
        username = ""
        demoMode = true
        gameMode = 0
        gameEvent = 0
        papermode = 0
    }

    function getGameEventText(index)
    {
        if (index === 0)
            return "40 Shots Match"
        if (index === 1)
            return "60 Shots Match"

        return "Free Practice"
    }

    function getPaperModeText(index)
    {
        if (index === 0)
            return "Standard"
        if (index === 1)
            return "Dual Shots"
        if (index === 2)
            return "Pro Mode"
        else
            return "Multiple Shots"
    }

    Image {
        id: bgRectImg
        source: "qrc:/images/loginPage/bgRectImg.png"
        x: ((parent.width/rootItemWidth)*0)
        y: ((parent.height/rootItemHeight)*0)
        opacity: 1
        anchors.fill: parent
        width: ((parent.width/rootItemWidth)*sourceSize.width)
        height: ((parent.height/rootItemHeight)*sourceSize.height)
    }
    Image {
        id: bg
        source: "qrc:/images/loginPage/bg.png"
        x: ((parent.width/rootItemWidth)*0)
        y: ((parent.height/rootItemHeight)*0)
        opacity: 1
        anchors.fill: parent
        width: ((parent.width/rootItemWidth)*sourceSize.width)
        height: ((parent.height/rootItemHeight)*sourceSize.height)
    }

    Image {
        id: image_icon
        source: "qrc:/images/loginPage/image_icon.png"
        x: ((parent.width/rootItemWidth)*354)
        y: ((parent.height/rootItemHeight)* 14)
        opacity: 1
        width: ((parent.width/rootItemWidth)*sourceSize.width)
        height: ((parent.height/rootItemHeight)*sourceSize.height)
    }
    Image {
        id: upload_image_icon
        visible: true
        source: "qrc:/images/loginPage/upload_image_icon.png"
        x: ((parent.width/rootItemWidth)*386)
        y: ((parent.height/rootItemHeight)*91)
        opacity: 1
        width: ((parent.width/rootItemWidth)*sourceSize.width)
        height: ((parent.height/rootItemHeight)*sourceSize.height)

        MouseArea {
            property bool onItem: false
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                onItem = true
            }

            onExited: {
                onItem = false
            }

            ToolTip.visible: onItem
            ToolTip.text: qsTr("Upload image")
        }

    }

    Image {
        id: name
        source: "qrc:/images/loginPage/name.png"
        x: ((parent.width/rootItemWidth)*261)
        y: ((parent.height/rootItemHeight)*115)
        opacity: 1
        width: ((parent.width/rootItemWidth)*sourceSize.width)
        height: ((parent.height/rootItemHeight)*sourceSize.height)
    }

    TextInput {
        id: name_text_field
        anchors.fill: name
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 5
        font.pixelSize: 0.5* height
        horizontalAlignment: TextInput.AlignHCenter
    }

    Image {
        id: demo
        source: "qrc:/images/loginPage/demo.png"
        x: ((parent.width/rootItemWidth)*211)
        y: ((parent.height/rootItemHeight)*480)
        opacity: demo_over.opacity === 1 ? 0 : 1
        width: ((bgRect.width/rootItemWidth)*sourceSize.width)
        height: ((bg.height/rootItemHeight)*sourceSize.height)
        fillMode: Image.PreserveAspectFit
    }
    Image {
        id: demo_over
        source: "qrc:/images/loginPage/demo_over.png"
        x: ((parent.width/rootItemWidth)*211)
        y: ((parent.height/rootItemHeight)*480)

        opacity: demoMode ? 1 : 0
        fillMode: Image.PreserveAspectFit
        MouseArea {
            id: demo_mouse
            anchors.fill: demo_over
            onClicked: {
                demoMode = !demoMode
            }
        }
    }

    Image {
        id: pistol
        source: "qrc:/images/loginPage/pistol.png"
        x: ((parent.width/rootItemWidth)*229)
        y: ((bgRectImg.height/rootItemHeight)*212)
        opacity: pistol_over.opacity === 1 ? 0 : 1
        width: ((parent.width/rootItemWidth)*sourceSize.width)
        height: ((parent.height/rootItemHeight)*sourceSize.height)
    }
    Image {
        id: pistol_over
        source: "qrc:/images/loginPage/pistol_over.png"
        x: ((parent.width/rootItemWidth)*229)
        y: ((bgRectImg.height/rootItemHeight)*212)
        opacity: gameMode === 0 ? 1 : 0
        width: ((parent.width/rootItemWidth)*sourceSize.width)
        height: ((parent.height/rootItemHeight)*sourceSize.height)
    }

    MouseArea {
        id: pistolMouse
        anchors.fill: pistol_over
        onClicked : {
            papermode = 0
            gameMode = 0
        }
    }

    Image {
        id: rifle
        source: "qrc:/images/loginPage/rifle.png"
        x: ((parent.width/rootItemWidth)*403)
        y: ((parent.height/rootItemHeight)*212)
        opacity: rifle_over.opacity === 1 ? 0 : 1
        fillMode: Image.PreserveAspectFit
    }
    Image {
        id: rifle_over
        source: "qrc:/images/loginPage/rifle_over.png"
        x: ((parent.width/rootItemWidth)*403)
        y: ((parent.height/rootItemHeight)*(192+ 20))
        opacity: gameMode === 1 ? 1 : 0
        fillMode: Image.PreserveAspectFit
    }
    MouseArea {
        id: rifleMouse
        anchors.fill: rifle_over
        onClicked: {
            papermode = 0
            gameMode = 1
        }
    }

    Image {
        id: shots_40_match
        source: "qrc:/images/loginPage/shots_40_match.png"
        x: ((parent.width/rootItemWidth)*299)
        y: ((parent.height/rootItemHeight)*269)
        opacity: 1
        fillMode: Image.PreserveAspectFit
    }
    Image {
        id: shots_40_match_text_field
        source: "qrc:/images/loginPage/shots_40_match_text_field.png"
        x: ((parent.width/rootItemWidth)*299)
        y: ((parent.height/rootItemHeight)*269)
        opacity: 0
        width: 0.75 * shots_40_match.width
        height: shots_40_match.height
    }

    Text {
        id: gameEventText
        width: implicitWidth
        height: implicitHeight
        anchors.verticalCenter: shots_40_match_text_field.verticalCenter
        anchors.horizontalCenter: shots_40_match_text_field.horizontalCenter

        text : getGameEventText(gameEvent)
        color: "white"
    }

    MouseArea {
        id: gameEventMouse
        anchors.fill: shots_40_match
        onClicked: {
            papermodeList.visible = false
            gameEventList.visible = true
        }
    }

    ListView {
        id: gameEventList
        anchors.top: shots_40_match_text_field.bottom
        anchors.topMargin: 5
        anchors.left: shots_40_match_text_field.left
        width: shots_40_match_text_field.width
        height: 3*shots_40_match_text_field.height
        visible: false
        z: 10

        model: 3

        delegate: Rectangle {
            width: parent.width
            height: shots_40_match_text_field.height
            border.width: 1
            border.color: "black"
            color: gameEvent === index ? "red" : "#2698d5"

            onVisibleChanged: {
                color = (gameEvent === index) ? "red" : "#2698d5"
            }

            Text {
                width: implicitWidth
                height: implicitHeight
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                text: getGameEventText(index)
                color: "white"
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    parent.color = "green"
                }

                onExited: {
                    parent.color = (gameEvent === index) ? "red" : "#2698d5"
                }

                onClicked: {
                    gameEvent = index
                    gameEventList.visible = false
                }
            }
        }
    }

    Image {
        id: standard
        source: "qrc:/images/loginPage/standard.png"
        x: ((parent.width/rootItemWidth)*300)
        y: ((parent.height/rootItemHeight)*375)
        opacity: gameMode === 0 ? 1 : 0
        fillMode: Image.PreserveAspectFit
    }
    Image {
        id: standard1
        source: "qrc:/images/loginPage/standard1.png"
        x: ((parent.width/rootItemWidth)*300)
        y: ((parent.height/rootItemHeight)*375)
        opacity: standard.opacity === 1 ? 0 : 1
        fillMode: Image.PreserveAspectFit
    }
    Image {
        id: standard_text_field
        source: "qrc:/images/loginPage/standard_text_field.png"
        x: ((parent.width/rootItemWidth)*300)
        y: ((parent.height/rootItemHeight)*375)
        opacity: 0
        width: 0.75 * standard.width
        height: standard.height
    }

    Text {
        id: paperModeText
        width: implicitWidth
        height: implicitHeight
        anchors.verticalCenter: standard_text_field.verticalCenter
        anchors.horizontalCenter: standard_text_field.horizontalCenter

        text : getPaperModeText(papermode)
        color: "white"
    }

    MouseArea {
        anchors.fill: standard
        onClicked: {
            if (gameMode === 0)
            {
                papermodeList.visible = true
                gameEventList.visible = false
            }
        }
    }

    ListView {
        id: papermodeList
        anchors.top: standard_text_field.bottom
        anchors.topMargin: 2
        anchors.left: standard_text_field.left
        width: standard_text_field.width
        visible: false
        z: 10

        model: 4

        height: 4 * standard_text_field.height

        delegate: Rectangle {
            width: parent.width
            height: standard_text_field.height
            border.width: 1
            border.color: "black"
            color: papermode === index ? "red" : "#2698d5"

            onVisibleChanged: {
                color = (papermode === index) ? "red" : "#2698d5"
            }

            Text {
                width: implicitWidth
                height: implicitHeight
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                text: getPaperModeText(index)
                color: "white"
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    parent.color = "green"
                }

                onExited: {
                    parent.color = (papermode === index) ? "red" : "#2698d5"
                }

                onClicked: {
                    papermode = index
                    papermodeList.visible = false
                }
            }
        }
    }

    Image {
        id: start
        source: "qrc:/images/loginPage/start.png"
        x: ((parent.width/rootItemWidth)*317)
        y: ((parent.height/rootItemHeight)*466)
        opacity: 1
        fillMode: Image.PreserveAspectFit
    }

    MouseArea {
        anchors.fill: start
        onClicked: {
            if (validate())
                rootItem.visible = false
        }
        onPressed: {
            start.visible = false
            start_over.visible = true
        }
        onPressAndHold: {
            start.visible = false
            start_over.visible = true
        }
        onReleased: {
            start.visible = true
            start_over.visible = false
        }
    }

    Image {
        id: start_over
        source: "qrc:/images/loginPage/start_over.png"
        x: ((parent.width/rootItemWidth)*317)
        y: ((parent.height/rootItemHeight)*466)
        opacity: 1
        fillMode: Image.PreserveAspectFit
    }
    Image {
        id: device_conhnected
        source: "qrc:/images/loginPage/device_conhnected.png"
        x: ((parent.width/rootItemWidth)*35)
        y: ((parent.height/rootItemHeight)*648)
        opacity: 1
        fillMode: Image.PreserveAspectFit
    }
    Image {
        id: device_conhnected_blue
        source: "qrc:/images/loginPage/device_conhnected_blue.png"
        x: ((parent.width/rootItemWidth)*35)
        y: ((parent.height/rootItemHeight)*654)
        opacity: 0
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: license_details
        source: "qrc:/images/loginPage/license_details.png"
        x: ((parent.width/rootItemWidth)*259)
        y: ((parent.height/rootItemHeight)*646)
        opacity: 1
        fillMode: Image.PreserveAspectFit
    }
    MouseArea {
        anchors.fill: license_details
        onClicked: {
        }
        onPressed: {
            license_details.visible = false
            license_details_over.visible = true
        }
        onPressAndHold: {
            license_details.visible = false
            license_details_over.visible = true
        }
        onReleased: {
            license_details.visible = true
            license_details_over.visible = false
        }
    }

    Image {
        id: license_details_over
        source: "qrc:/images/loginPage/license_details_over.png"
        x: ((parent.width/rootItemWidth)*259)
        y: ((parent.height/rootItemHeight)*646)
        opacity: 1
        visible: false
        fillMode: Image.PreserveAspectFit
    }
    Image {
        id: open_saved_files
        source: "qrc:/images/loginPage/open_saved_files.png"
        x: ((parent.width/rootItemWidth)*411)
        y: ((parent.height/rootItemHeight)*646)
        opacity: 1
        fillMode: Image.PreserveAspectFit
    }
    MouseArea {
        anchors.fill: open_saved_files
        onClicked: {
        }
        onPressed: {
            open_saved_files.visible = false
            open_saved_files_over.visible = true
        }
        onPressAndHold: {
            open_saved_files.visible = false
            open_saved_files_over.visible = true
        }
        onReleased: {
            open_saved_files.visible = true
            open_saved_files_over.visible = false
        }
    }
    Image {
        id: open_saved_files_over
        source: "qrc:/images/loginPage/open_saved_files_over.png"
        x: ((parent.width/rootItemWidth)*411)
        y: ((parent.height/rootItemHeight)*646)
        opacity: 1
        visible: false
        fillMode: Image.PreserveAspectFit
    }
    Image {
        id: user_guide
        source: "qrc:/images/loginPage/user_guide.png"
        x: ((parent.width/rootItemWidth)*1004)
        y: ((parent.height/rootItemHeight)*646)
        opacity: 1
        fillMode: Image.PreserveAspectFit
    }
    MouseArea {
        anchors.fill: user_guide
        onClicked: {
        }
        onPressed: {
            user_guide.visible = false
            user_guide_over.visible = true
        }
        onPressAndHold: {
            user_guide.visible = false
            user_guide_over.visible = true
        }
        onReleased: {
            user_guide.visible = true
            user_guide_over.visible = false
        }
    }
    Image {
        id: user_guide_over
        source: "qrc:/images/loginPage/user_guide_over.png"
        x: ((parent.width/rootItemWidth)*1004)
        y: ((parent.height/rootItemHeight)*646)
        opacity: 1
        visible: false
        fillMode: Image.PreserveAspectFit
    }
    Image {
        id: reset
        source: "qrc:/images/loginPage/reset.png"
        x: ((parent.width/rootItemWidth)*510)
        y: ((parent.height/rootItemHeight)*480)
        opacity: 1
        fillMode: Image.PreserveAspectFit

        MouseArea {
            anchors.fill: parent
            onClicked: rootItem.reset()
            onPressed: {
                reset.visible = false
                reset_over.visible = true
            }
            onPressAndHold: {
                reset.visible = false
                reset_over.visible = true
            }
            onReleased: {
                reset.visible = true
                reset_over.visible = false
            }
        }
    }

    Image {
        id: reset_over
        source: "qrc:/images/loginPage/reset_over.png"
        x: ((parent.width/rootItemWidth)*510)
        y: ((parent.height/rootItemHeight)*480)
        opacity: 1
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: contact_us
        source: "qrc:/images/loginPage/contact_us.png"
        x: ((parent.width/rootItemWidth)*1185)
        y: ((parent.height/rootItemHeight)*646)
        opacity: 1
        fillMode: Image.PreserveAspectFit
        MouseArea {
            anchors.fill: parent
            //onClicked: rootItem.reset()
            onPressed: {
                contact_us.visible = false
                contact_us_over.visible = true
            }
            onPressAndHold: {
                contact_us.visible = false
                contact_us_over.visible = true
            }
            onReleased: {
                contact_us.visible = true
                contact_us_over.visible = false
            }
        }
    }
    Image {
        id: contact_us_over
        source: "qrc:/images/loginPage/contact_us_over.png"
        x: ((parent.width/rootItemWidth)*1185)
        y: ((parent.height/rootItemHeight)*646)
        opacity: 1
        visible: false
        fillMode: Image.PreserveAspectFit
    }
}
