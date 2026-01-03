import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import "root:/utils"

CustomBackground {
    id: root
    property ShellScreen screen

    containerWidth: row.implicitWidth + 16

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 8
        visible: SystemTray.items.values.length > 0

        Repeater {
            model: SystemTray.items

            TrayItemWidget {
                screen: root.screen
            }
        }
    }
}
