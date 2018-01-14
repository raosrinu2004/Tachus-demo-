import QtQuick 2.2
Item {
    property int rootItemWidth:1366
    property int rootItemHeight:45
    signal close()
    signal minimize()

    Rectangle {
        id: fullRect
        color: "#202020"
        anchors.fill: parent
    }

    Image {
        id: bg
        source: "qrc:/images/header/bg.png"
        x: ((parent.width/rootItemWidth)*0)
        y: ((parent.height/rootItemHeight)*0)
        opacity: 1
        fillMode: Image.PreserveAspectFit
    }
    Image {
        id: minimizeButton
        source: "qrc:/images/header/minimize.png"
        x: ((parent.width/rootItemWidth)*1258)
        y: ((parent.height/rootItemHeight)*5)
        opacity: 1
        fillMode: Image.PreserveAspectFit

        MouseArea {
            anchors.fill: parent
            onClicked: minimize()
        }
    }
    Image {
        id: closeButton
        source: "qrc:/images/header/close.png"
        x: ((parent.width/rootItemWidth)*1304)
        y: ((parent.height/rootItemHeight)*5)
        opacity: 1
        fillMode: Image.PreserveAspectFit

        MouseArea {
            anchors.fill: parent
            onClicked: close()
        }
    }
}
