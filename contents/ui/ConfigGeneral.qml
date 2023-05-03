import QtQuick 2.0
import QtQuick.Controls 1.0 as QtControls
import QtQuick.Layouts 1.1 as QtLayouts
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras

Item {
    id: iconsPage

    width: childrenRect.width
    height: childrenRect.height
    implicitWidth: pageColumn.implicitWidth
    implicitHeight: pageColumn.implicitHeight

    SystemPalette {
        id: sypal
    }

    QtLayouts.ColumnLayout {
        id: pageColumn

        anchors.left: parent.left

        PlasmaExtras.Heading {
            text: i18nc("TOD", "No config options (yet)")
            color: syspal.text
            level: 3
        }

    }

}
