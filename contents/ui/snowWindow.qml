import "../code/utils.js" as Utils
import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.2
import org.kde.plasma.plasmoid 2.0

ApplicationWindow {
    id: root

    property int dir: getRandomIntInclusive(0, 1) // could go either left or right
    property int radius: Utils.getSnowSize(plasmoid.configuration.userSize) // size of snowflake
    property int swirl: getRandomIntInclusive(35, 200) // random falling 'swirl'
    property int disposition: 0
    property alias snowFlakeRotation: snowFlake.rotation
    property int rotationSpeed: getRandomIntInclusive(1, 4)
    property int rotationDirection: getRandomIntInclusive(0, 1)
    property int fallingSpeed: Utils.getFallingSpeed(plasmoid.configuration.userSpeed)

    // Basic functions (fro, developer.mozilla.org)
    function getRandomIntInclusive(min, max) {
        min = Math.ceil(min);
        max = Math.floor(max);
        return Math.floor(Math.random() * (max - min + 1) + min);
    }

    opacity: 0.5
    color: "transparent"
    flags: Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint | Qt.WA_TransparentForMouseEvents | Qt.WA_TranslucentBackground | Qt.X11BypassWindowManagerHint

    Rectangle {
        id: snowFlake

        anchors.fill: parent
        radius: plasmoid.configuration.userStyle == "Plain" ? 50 : 0
        color: plasmoid.configuration.userStyle == "Plain" ? "white" : "transparent"

        Image {
            id: snowFlakeImage

            function setImage() {
                var imgSrc = "";
                switch (plasmoid.configuration.userStyle) {
                case "Classic":
                    imgSrc = "../images/classic.png";
                    break;
                case "Plain":
                    break;
                case "Romantic":
                    imgSrc = "../images/romantic.png";
                    break;
                }
                return imgSrc;
            }

            anchors.fill: parent
            source: setImage()
        }

    }

}
