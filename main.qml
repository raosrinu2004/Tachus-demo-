import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtWinExtras 1.0
import QtQuick.Window 2.2

ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    property string userName: "Tachus"
    property string eventName: shootingPage.currentGameDisplay1 + " " + shootingPage.currentGameDisplay2
    property string eventDate: "9/3/2017 4:34 PM"
    property string numberOfShots: "10"
    property string averageScore : "9.68"
    property string averageTime : "00:12"
    property int totalScore : shootingPage.totalScore
    property int totalTime: shootingPage.totalTime
    property int scWidth: Screen.width
    property int scHeight: Screen.height

    flags: Qt.FramelessWindowHint | Qt.Window

    ListModel
    {
        id:globalModelOfData
    }

    ListModel {
        id: gameEventModel

        ListElement {
            name: "10M AIR RIFLE FREE"
            count: -1
            gameDisplay1: "10M AIR"
            gameDisplay2: "RIFLE"
            matchDisplay: "UN-LIMITED"
        }
        ListElement {
            name: "10M AIR RIFLE 40"
            count: 40
            gameDisplay1: "10M AIR"
            gameDisplay2: "RIFLE"
            matchDisplay: "MATCH-40"
        }
        ListElement {
            name: "10M AIR RIFLE 60"
            count: 60
            gameDisplay1: "10M AIR"
            gameDisplay2: "RIFLE"
            matchDisplay: "MATCH-60"
        }
        ListElement {
            name: "10M AIR PISTOL FREE"
            count: -1
            gameDisplay1: "10M AIR"
            gameDisplay2: "PISTOL"
            matchDisplay: "UN-LIMITED"
        }
        ListElement {
            name: "10M AIR PISTOL 40"
            count: 40
            gameDisplay1: "10M AIR"
            gameDisplay2: "PISTOL"
            matchDisplay: "MATCH-40"
        }
        ListElement {
            name: "10M AIR PISTOL 60"
            count: 60
            gameDisplay1: "10M AIR"
            gameDisplay2: "PISTOL"
            matchDisplay: "MATCH-60"
        }
    }


    Component.onCompleted: {
        shootingPage.setCurrentGameType(1)
    }

//    visibility: "FullScreen"
    visibility: "Maximized"

    Rectangle {
        id: fullRect
        color: "#202020"
        anchors.fill: parent
    }

    Header {
        id: header
        width: parent.width
        height: 40
        anchors.top: parent.top
        z: 5

        onMinimize: {
            window.visibility = "Minimized"
        }

        onClose: {
            window.close()
        }
    }

    ShootingPage {
        id: shootingPage
        z: 0
        height: parent.height - header.height
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        visible: !loginPage.visible

        Component.onCompleted: {
            setCurrentGameType(4)
        }
    }

    LoginPage {
        id: loginPage

        height: parent.height - header.height
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        anchors.topMargin: 20

        onUsernameChanged: {
            window.userName = loginPage.username
        }

        onGameModeChanged: updateGameType()
        onGameEventChanged: updateGameType()

        function updateGameType()
        {
            if (gameMode === 0)
            {
                if (gameEvent === 0)
                    shootingPage.setCurrentGameType(4)
                else if (gameEvent === 1)
                    shootingPage.setCurrentGameType(5)
                else
                    shootingPage.setCurrentGameType(3)
            } else {
                if (gameEvent === 0)
                    shootingPage.setCurrentGameType(1)
                else if (gameEvent === 1)
                    shootingPage.setCurrentGameType(2)
                else
                    shootingPage.setCurrentGameType(0)
            }
        }
    }

    TaskbarButton {
        progress.visible: true
    }

//    SummaryPage {
//        id:showSummaryPage
//        visible: false
//        width:window.width*3/4
//        height:window.height*3/4

//    }
}
