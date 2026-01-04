import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

Item {
    id: root
    required property SystemTrayItem modelData
    property ShellScreen screen

    implicitHeight: 20
    implicitWidth: 20

    IconImage {
        implicitSize: 20
        source: root.modelData.icon
        mipmap: true

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: mouse => {
                if (mouse.button === Qt.LeftButton) {
                    root.modelData.activate();
                } else if (mouse.button === Qt.RightButton) {
                    TrayMenuState.toggleItemMenu(root.modelData.icon, root.screen.name);
                }
            }
        }
    }

    TrayItemMenuWidget {
        trayItemData: root.modelData
        screenName: root.screen.name
    }
}
