import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import "root:/utils"

Rectangle {
    id: root
    property ShellScreen screen

    color: ThemeColors.base07
    radius: 999
    implicitHeight: row.implicitHeight
    implicitWidth: row.implicitWidth

    Row {
        id: row
        spacing: 8
        topPadding: 3
        bottomPadding: 3
        leftPadding: 4
        rightPadding: 4
        visible: SystemTray.items.values.length > 0

        Repeater {
            model: SystemTray.items

            TrayItemWidget {
                screen: root.screen
            }
        }
    }
}
