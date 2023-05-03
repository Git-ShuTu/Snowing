import "../code/utils.js" as Utils
import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0 as Plasmoid

Item {
    id: root

    property var snow: []
    property int snowCount: Utils.getSnowCount(plasmoid.configuration.userCount)
    readonly property int screenWidth: Qt.application.screens[0].width
    readonly property int screenHeight: Qt.application.screens[0].height

    function initializeSnow() {
        if (snowFalling.running)
            return ;

        for (var i = 0; i < snowCount; i++) {
            var component = Qt.createComponent("snowWindow.qml");
            snow[i] = component.createObject(root);
            snow[i].x = Math.random() * screenWidth;
            snow[i].y = Math.random() * screenHeight;
            snow[i].width = (Math.random() * 100) % snow[i].radius;
            snow[i].height = snow[i].width;
        }
    }

    function startSnow() {
        for (var i = 0; i < snowCount; i++) {
            snow[i].showMaximized();
        }
        snowFalling.running = true;
    }

    // End snow flake and start a 'random' new one
    function endSnowFlake(i) {
        snow[i].x = Math.random() * screenWidth;
        snow[i].y = -10;
        snow[i].width = (Math.random() * 100) % snow[i].radius;
        snow[i].height = snow[i].width;
        snow[i].showMaximized();
    }

    function destroySnow() {
        if (!snowFalling.running)
            return ;

        snowFalling.running = false;
        for (var i = 0; i < snowCount; i++) {
            snow[i].close();
            snow[i].destroy();
        }
    }

    function updateSnow() {
        if (userSpeed.currentText == '')
            return ;

        // set config for new snow flakes
        plasmoid.configuration.userStyle = userStyle.textAt(userStyle.currentIndex);
        plasmoid.configuration.userSize = userSize.textAt(userSize.currentIndex);
        plasmoid.configuration.userSpeed = userSpeed.textAt(userSpeed.currentIndex);
        if (!snowFalling.running || plasmoid.configuration.userSpeed == userSpeed.currentText)
            return ;

        // update current snow flakes
        for (var i = 0; i < snowCount; i++) {
            snow[i].fallingSpeed = Utils.getFallingSpeed(userSpeed.currentText);
        }
    }

    /* Update snow count works a bit differently;
	 * can either kill all (implemented now) and start over;
	 * or slowly add/delete new snow flakes  */
    function updateCount() {
        if (snowFalling == null)
            return ;

        var alreadyRunning = snowFalling.running;
        destroySnow();
        plasmoid.configuration.userCount = userCount.textAt(userCount.currentIndex);
        initializeSnow();
        if (alreadyRunning)
            startSnow();

    }

    width: 250
    height: 180
    Layout.minimumWidth: units.gridUnit * 14
    Layout.minimumHeight: units.gridUnit * 10

    GridLayout {
        id: gridLayout

        rows: 5
        flow: GridLayout.TopToBottom
        anchors.fill: parent

        Label {
            text: "Speed"
            color: theme.textColor
        }

        Label {
            text: "Size"
            color: theme.textColor
        }

        Label {
            text: "Style"
            color: theme.textColor
        }

        Label {
            text: "Count"
            color: theme.textColor
        }

        Button {
            id: letitsnow

            text: "snowing!"
            onClicked: {
                initializeSnow();
                startSnow();
            }
        }

        ComboBox {
            id: userSpeed

            width: 100
            model: ["Slow", "Normal", "Fast"]
            currentIndex: 1
            onCurrentIndexChanged: updateSnow()
        }

        ComboBox {
            id: userSize

            width: 100
            model: ["Tiny", "Small", "Big"]
            currentIndex: 2
            onCurrentIndexChanged: updateSnow()
        }

        ComboBox {
            id: userStyle

            width: 100
            model: ["Classic", "Plain", "Romantic"]
            currentIndex: 0
            onCurrentIndexChanged: updateSnow()
        }

        ComboBox {
            id: userCount

            width: 100
            model: ["Few", "Medium", "Many"]
            currentIndex: 1
            onCurrentIndexChanged: updateCount()
        }

        Button {
            width: 100
            text: "Stop"
            onClicked: destroySnow()
        }

    }

    Timer {
        id: snowFalling

        interval: 50
        running: false
        repeat: true
        onTriggered: {
            for (var i = 0; i < snowCount; i++) {
                if (snow[i].dir == 0)
                    snow[i].x += 2;
                else
                    snow[i].x -= 2;
                if (snow[i].disposition++ % snow[i].swirl == 0)
                    snow[i].dir = !snow[i].dir;

                if (snow[i].x > screenWidth)
                    snow[i].x = 0;
                else if (snow[i].x < 0)
                    snow[i].x = screenWidth;
                snow[i].y += snow[i].fallingSpeed;
                if (snow[i].y > screenHeight)
                    endSnowFlake(i);

                if (snow[i].rotationDirection == 0)
                    snow[i].snowFlakeRotation += snow[i].rotationSpeed;
                else
                    snow[i].snowFlakeRotation -= snow[i].rotationSpeed;
            }
        }
    }

}
