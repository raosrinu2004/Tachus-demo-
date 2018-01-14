import QtQuick 2.2
import QtCharts 2.2
import QtQuick.Window 2.2

Item {
    id:paneItem
    property var itemPoint: Qt.point(0,0)
    property double calculatedSccore: 0
    property double currentScoreValue: -1
    property double currentScoreDegree: -1
    property int shotCount: -1

    property bool lightBackGroundMode: true
    property bool gameMode: shootingPage.currentGameDisplay2 === "PISTOL" ? true : false // true for pistol

    signal pointAddedToSeries(real xPosition, real yPosition, real currentCalculatedScore)
    //    signal pointAddedXYPoints(real xPosition, real yPosition)

    property int gameTime: 0
    property int totalGameTime: 0
    property bool showPolarChart: false

    property int screenWidth : scWidth

    onGameModeChanged: {
        circleCordinates()
        innercircle.updateInnerCircleWidth()
        externalRect.updateExternalRectWidth()
    }

    onWidthChanged:
    {
        circleCordinates()
        externalRect.updateExternalRectWidth()
    }

    onHeightChanged:
    {
        circleCordinates()
        externalRect.updateExternalRectWidth()
    }

    Component.onCompleted:
    {
        externalRect.updateExternalRectWidth()
    }

    Timer {
        id:gameTimer
        interval: 1000
        repeat: true
        onTriggered: {
            gameTime++;
            var remainingTime = (totalGameTime - gameTime)*1
            var formatedTime = minutesToseconds(remainingTime)
            console.log("Formated Time is .......", formatedTime,remainingTime,
                        gameTime,totalGameTime)
            stopTimer.text = formatedTime
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#ffffdd"
        border.color: "blue"
    }

    Rectangle {
        id: shootingPanelRect
        anchors.fill: parent
        color: "transparent"

        Image {
            id: shootingcanvas
            anchors.margins: 10
            source: gameMode ? "qrc:/images/centerPanel/pistol.png" : "qrc:/images/centerPanel/rifle.png"
            anchors.centerIn: parent
            height: (parent.height > parent.width ? parent.width : parent.height) - anchors.margins
            width: height
            opacity: showPolarChart ? 0 : 1

//            Rectangle {
//                anchors.fill: parent
//                color: "green"
//                opacity: 0.5
//            }
        }

        PolarChartView {
            id:root
            anchors.fill: parent
            antialiasing: true
            backgroundColor: "transparent"
            opacity: showPolarChart ? 1 : 0

            Component.onCompleted:
            {
                legend.visible = false;
            }

            ValueAxis {
                id: axisAngular
                min: 0
                max: 360
                labelsVisible: false
                color: "transparent"
                gridLineColor: "transparent"
                gridVisible: false
                lineVisible: false
                minorGridVisible: false
            }

            ValueAxis {
                id: axisRadial
                min: 0
                max: gameMode ? 10 : 9
                tickCount: gameMode ? 11 : 10
                labelsVisible: false
                lineVisible: false
                gridLineColor: lightBackGroundMode ? "black" : "white"
            }

            ScatterSeries {
                id: polarSeries
                axisAngular: axisAngular
                axisRadial: axisRadial
                markerSize: screenWidth*0.1;//screenResolution.desktopAvailableWidth *0.1//25
                color: "green"
                borderColor: "grey"
                opacity: 0.5
                visible: false
                onPointAdded:
                {
                    var temp =  polarSeries.at(index)
                    console.log("point on main canvas "+ temp)
                    pointAddedToSeries(temp.x,temp.y, calculatedSccore)
                    paneItem.currentScoreDegree = temp.x
                    paneItem.currentScoreValue = calculatedSccore
                }
            }

            ScatterSeries {
                id: currentPolarSeriesItem
                axisAngular: axisAngular
                axisRadial: axisRadial
                markerSize: screenWidth*0.1 *0.1//25
                opacity: 0.5
                color: "red"
                visible: false
            }
        }

        Rectangle {
            id: externalRect
            anchors.centerIn: parent
            //width: !gameMode ? parent.height - (innercircle.width/innerCirclePartitionRepeater.count)/2 -2: parent.height -  innercircle.width/innerCirclePartitionRepeater.count + 7
            width: root.height - root.height/(axisRadial.tickCount)//gameMode ? (root.height/(axisRadial.tickCount))*10 : (root.height/(axisRadial.tickCount))*9.5 - 4

            height: width
            color: "transparent"
            border.color: "red"

            opacity: 0
            Component.onCompleted: {
                console.log("-----------width---", width)
                updateExternalRectWidth()
            }

            onWidthChanged: {
                console.log("-----------width########---", width)
                console.log("co-centric circle dimension ---x---", x,"---y---", y,"-----------width########---", width)
            }

            function updateExternalRectWidth()
            {
                var startinPosition = axisRadial.max
                width = root.mapToPosition(Qt.point(90,(startinPosition)),polarSeries).x - root.mapToPosition(Qt.point(270,(startinPosition)),polarSeries).x
            }
        }

        Rectangle
        {
            id:innercircle
            z:5
            visible: true
            width: gameMode ? (root.width/(axisRadial.tickCount))*4 : (root.width/(axisRadial.tickCount))*6
            opacity: showPolarChart ? 1 : 0

            height: width
            radius:width/2
            color: "black"
//            opacity: 0.3

            anchors.centerIn: root

            function updateInnerCircleWidth()
            {
                var temp = gameMode ? 4 : 6
                innercircle.width = root.height > root.width ?
                        (root.width/(axisRadial.tickCount))*temp:
                        (root.height/(axisRadial.tickCount))*temp
                console.log("game ", gameMode, " --- ", temp)
            }

            onWidthChanged: {
                height = width
                radius = width/2
            }

            Component.onCompleted: {
                updateInnerCircleWidth()
            }

            Repeater {
                id: innerCirclePartitionRepeater
                model: 4
                visible: gameMode

                delegate: Rectangle {
                    anchors.centerIn: innercircle
                    width: (index+1)* (innercircle.width/innerCirclePartitionRepeater.count)
                    height: width
                    radius: width/2
                    border.color: "white"
                    color: "transparent"
                    visible: index === innerCirclePartitionRepeater.count - 1 ? false : gameMode
                }
            }

            Repeater {
                id: innerCirclePartitionRepeaterRifle
                model: 6
                visible: !gameMode

                delegate: Rectangle {
                    anchors.centerIn: innercircle
                    width: (index+1)* (innercircle.width/innerCirclePartitionRepeaterRifle.count)
                    height: width
                    radius: width/2
                    border.color: "white"
                    color: "transparent"
                    visible: index === innerCirclePartitionRepeaterRifle.count - 1 ? false : !gameMode
                }
            }

            Rectangle {
                id: centerCircle
                anchors.centerIn: parent
                width: gameMode ? (innercircle.width/innerCirclePartitionRepeater.count)/2 : 5
                height: width
                radius: width/2
                color: gameMode ? "transparent" : "white"
                border.color: "white"
            }
        }

        Rectangle {
            id: animatorCircle
            width: polarSeries.markerSize*4
            height: polarSeries.markerSize*4
            color: "transparent"
            border.color: "red"
            border.width: 2
            radius: width/2
            visible: false
            z: 20

            ParallelAnimation {
                id: pAnimationCircle
                ScaleAnimator {
                    target: animatorCircle
                    from: 1
                    to: 0.25
                    duration: 500
                }
                running: true

                onStopped: {
                    animatorCircle.visible = false
                    var temp = root.mapToValue(paneItem.itemPoint,polarSeries);
                    //                pointAddedXYPoints(itemPoint.x, itemPoint.y)
                    addIfinRange(temp)
                }
            }

            onVisibleChanged: {
                if (visible)
                    pAnimationCircle.start()
            }
        }

        Repeater
        {
            id:scoreIndicator
            model:8
            delegate: numberDelegate
        }
        Component {
            id:numberDelegate

            Item {
                property double startinPosition: gameMode ? 9.5 : 8.5
                opacity: showPolarChart ? 1 : 0

                z: 20
                Item {
                    id:leftItem
                    width:15
                    height: 15
                    x: (root.mapToPosition(Qt.point(270,(startinPosition - index*1)),polarSeries).x) - (width/2)
                    y: (root.mapToPosition(Qt.point(270,(startinPosition - index*1)),polarSeries).y) - (width/2)
                    Rectangle
                    {
                        anchors.fill: parent
                        radius:parent.width/2
                        color:"transparent"
                        Text{
                            anchors.centerIn: parent
                            text: index+1
                            color: gameMode ? (index>5 ? "white" : "black") : (index>2 ? "white" : "black")
                        }
                    }
                }
                Item {
                    id:topItem
                    width:15
                    height: 15
                    x: (root.mapToPosition(Qt.point(0,(startinPosition - index*1)),polarSeries).x) - (width/2)
                    y: (root.mapToPosition(Qt.point(0,(startinPosition - index*1)),polarSeries).y) - (width/2)
                    Rectangle
                    {
                        anchors.fill: parent
                        radius:parent.width/2
                        color:"transparent"
                        Text{
                            anchors.centerIn: parent
                            text: index+1
                            color: gameMode ? (index>5 ? "white" : "black") : (index>2 ? "white" : "black")
                        }
                    }
                }
                Item {
                    id:rightItem
                    width:15
                    height: 15
                    z:10
                    x: (root.mapToPosition(Qt.point(90,(startinPosition - index*1)),polarSeries).x) - (width/2)
                    y: (root.mapToPosition(Qt.point(90,(startinPosition - index*1)),polarSeries).y) - (width/2)
                    Rectangle
                    {
                        anchors.fill: parent
                        radius:parent.width/2
                        color:"transparent"
                        Text{
                            anchors.centerIn: parent
                            text: index+1
                            color: gameMode ? (index>5 ? "white" : "black") : (index>2 ? "white" : "black")
                        }
                    }
                }
                Item {
                    id:bottomItem
                    width:15
                    height: 15
                    z:10
                    x: (root.mapToPosition(Qt.point(180,(startinPosition - index*1)),polarSeries).x) - (width/2)
                    y: (root.mapToPosition(Qt.point(180,(startinPosition - index*1)),polarSeries).y) - (width/2)
                    Rectangle
                    {
                        anchors.fill: parent
                        radius:parent.width/2
                        color:"transparent"
                        Text{
                            anchors.centerIn: parent
                            text: index+1
                            color: gameMode ? (index>5 ? "white" : "black") : (index>2 ? "white" : "black")
                        }
                    }
                }
            }
        }

        Repeater
        {
            id:numberOverlayRepeater
            model:globalModelOfData
            delegate: numberOverlayDelegate
        }

        Component {
            id:numberOverlayDelegate
            Item {
                id:mainItem
                width: gameMode ? shootingcanvas.height/34.55 : shootingcanvas.height/10.11
                height: width
                z: 15
                Rectangle
                {
                    Component.onCompleted:
                    {
                        var left = Qt.point(direction*1,score*1);
                        left = root.mapToPosition(left,polarSeries);
                        mainItem.x = root.x + left.x - radius
                        mainItem.y = root.y + left.y - radius
                        if(sligterMode)
                        {
//                            if(score > axisRadial.max)
//                                visible = false
//                            else
                                visible = true
                        }
                        else
                        {
                            //Non - Slighter Mode
                            var checkIndex = currentPageIndexOfSer*10 - 1
                            if( (index > checkIndex) && (index <= (checkIndex+10)) )
                            {
//                                if(score > axisRadial.max)
//                                    visible = false
//                                else
                                    visible = true
                            }
                            else
                            {
                                visible = false
                            }

                        }

                        //Check Last Item and update color
                        if(index === globalModelOfData.count-1)
                        {
                            //Last item
                            color = "red"
                            opacity = 0.8
                        }
                    }
                    anchors.fill: parent
                    radius:parent.width/2
                    color: "white"
                    opacity: 0.5
                    border.color: "grey"
                    //                border.width: 2
                    Text{
                        anchors.centerIn: parent
                        text: index+1
                    }
                }
            }
        }
    }

    MouseArea{
        anchors.fill:parent
        onClicked:
        {
            if (!shootingPanelRect.visible)
                return

            if(matchFinished)
            {
                matchInfoDialog.visible = true
                return
            }
//            if (shotCount != -1 && shotCount <= globalModelOfData.count)
//                return

            console.log("--x--", mouseX, "--y--", mouseY,"mapped points --- ", mapToItem(shootingcanvas, mouseX, mouseY))

            itemPoint.x = mouseX/shootingPanelRect.scale + (mapToItem(root,0,0).x)
            itemPoint.y = mouseY/shootingPanelRect.scale + (mapToItem(root,0,0).y)

            calculateShootingSocre(itemPoint.x, itemPoint.y)
            console.log("--- mouse click point-- x -> ", itemPoint.x, " y -> ", itemPoint.y)
            animatorCircle.x = (itemPoint.x - animatorCircle.width/2)
            animatorCircle.y = (itemPoint.y - animatorCircle.width/2)
            animatorCircle.visible = true
        }
    }

    Image {
        id: sighter
        source: "qrc:/images/centerPanel/corner-tri.png"
        anchors.top: parent.top
        anchors.right: parent.right

        width: 0.2*parent.width
        height: width
    }

    Text {
        id: stopTimer
        anchors.top: parent.top
        anchors.right: parent.right
        width: 0.2*parent.width
        height: width
        visible: !sighter.visible
        text : "00:00"

        Component.onCompleted:
        {
            var remainingTime = (totalGameTime - gameTime)*1
            var formatedTime = minutesToseconds(remainingTime)
            stopTimer.text = formatedTime
        }
    }


    Rectangle {
        id: finalShootNotificationRect
        width: 300
        height: 50
        z: 20
        color: "red"
        opacity: 0.7

        visible: (shotCount != -1) && (globalModelOfData.count === (shotCount-1))

        onVisibleChanged: {
            showAnimation.start()
        }

        anchors.top: parent.top
        anchors.topMargin: 50

        Text {
            anchors.centerIn: parent
            text: "Final shot of the match"
            font.pixelSize: (0.5*parent.height)
            color: "white"
        }

        NumberAnimation on x {
            id: showAnimation
            from: -parent.width; to: 0
            duration: 500
        }
    }

    Image {
        id: currentScoreBGImage
        source: "qrc:/images/centerPanel/Circle.png"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10

        width: 0.15*parent.width
        height: width

        rotation: paneItem.currentScoreDegree === -1 ? -45 : paneItem.currentScoreDegree - 45
        transformOrigin: Item.Center
    }

    Text {
        id: currentScoreText
        width: implicitWidth
        height: 0.6*currentScoreBGImage.height
        font.pixelSize: (0.65*height)
        color: "red"
        anchors.centerIn: currentScoreBGImage
        text: paneItem.currentScoreValue === -1 ? "" : paneItem.currentScoreValue
    }

    Rectangle {
        id: zoomRect
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10

        color: "transparent"

        width: 50
        height: 120

        Image {
            id: zoomOut
            source: "qrc:/images/centerPanel/zoomOut.png"
            anchors.top: parent.top

            width: parent.width
            height: parent.height/2
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (shootingPanelRect.scale > 1)
                        shootingPanelRect.scale -= 0.2
                }
            }
        }

        Image {
            id: zoomIn
            source: "qrc:/images/centerPanel/zoomIn.png"
            anchors.top: zoomOut.bottom

            width: parent.width
            height: parent.height/2

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (shootingPanelRect.scale < 1.6)
                        shootingPanelRect.scale += 0.2
                }
            }
        }
    }

    function addIfinRange(shootPoint)
    {
        if (!root.visible)
            return

        console.log(" x ", shootPoint.x, " y ", shootPoint.y)
        //        if(shootPoint.x >= axisAngular.min && shootPoint.x <= axisAngular.max
        //                && shootPoint.y >= axisRadial.min && shootPoint.y <=axisRadial.max )
        //        {
        currentPolarSeriesItem.clear()
        polarSeries.append(shootPoint.x, shootPoint.y)
        currentPolarSeriesItem.append(shootPoint.x, shootPoint.y)
        //        }
    }
    function circleCordinates()
    {
        if (!paneItem.visible)
            return;

        if (gameMode)
        {
            var left = Qt.point(270,4);
            left = root.mapToPosition(left,polarSeries);
            var right = Qt.point(90,4);
            right = root.mapToPosition(right,polarSeries);
            var top = Qt.point(360,4);
            top = root.mapToPosition(top,polarSeries);
            var bottom = Qt.point(180,4);
            bottom = root.mapToPosition(bottom,polarSeries);

            innercircle.x = left.x
            innercircle.y = top.y
            innercircle.width = right.x - left.x
        } else {
            var left1 = Qt.point(270,6);
            left1 = root.mapToPosition(left1,polarSeries);
            var right1 = Qt.point(90,6);
            right1 = root.mapToPosition(right1,polarSeries);
            var top1 = Qt.point(360,6);
            top1 = root.mapToPosition(top1,polarSeries);
            var bottom1 = Qt.point(180,6);
            bottom1 = root.mapToPosition(bottom1,polarSeries);

            innercircle.x = left1.x
            innercircle.y = top1.y
            innercircle.width = right1.x - left1.x
        }

        innercircle.height = innercircle.width
        innercircle.radius = innercircle.width/2

        scoreIndicator.model = null
        scoreIndicator.model = 8
    }

    function currentPageIndexChanged()
    {
        numberOverlayRepeater.model = null
        numberOverlayRepeater.model = globalModelOfData
    }

    function showSlighter(sighterVisible)
    {
        sighter.visible = sighterVisible
        if(!sighterVisible)
            gameTimer.start()
        else
            gameTimer.stop()
    }

    function calculateShootingSocre(xPoint, yPoint)
    {
        var clickedX = mapToItem(shootingcanvas, xPoint, yPoint).x
        var clcikedY = mapToItem(shootingcanvas, xPoint, yPoint).y
        var canvasMidX = shootingcanvas.width/2

        var radius = Math.sqrt(Math.pow(canvasMidX-clickedX, 2)+Math.pow(canvasMidX-clcikedY, 2))
        var mapedRadius = gameMode ? (radius*155.5) / shootingcanvas.width : (radius*45.5) / shootingcanvas.width

        if (gameMode)
        {
            if (mapedRadius > 80)
                calculatedSccore = 0
            else
                calculatedSccore = ((Math.floor((11 - (((mapedRadius + 0.1)/0.8)*0.1))*10))*0.1).toFixed(1)
        } else {
            if (mapedRadius > 25)
                calculatedSccore = 0
            else
                calculatedSccore = ((Math.floor((11 - (((mapedRadius + 0.01)/0.25)*0.1))*10))*0.1).toFixed(1)
        }

//        calculatedSccore
        console.log(calculatedSccore,"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@", mapedRadius)
    }

//    function minutesToseconds(totalSecs)
//    {
//        var minutes = Math.floor(totalSecs / 60);
//        var seconds = totalSecs - minutes * 60;
//        var finalTime = str_pad_left(minutes,'0',2)+':'+str_pad_left(seconds,'0',2);
//        return finalTime
//    }

//    function str_pad_left(string,pad,length) {
//        return (new Array(length+1).join(pad)+string).slice(-length);
//    }

}
