//@ pragma UseQApplication
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import "./widgets/tray"

Scope {
    Bar {}

    // Fullscreen overlay for click-outside-to-close on tray menus
    Variants {
        model: Quickshell.screens

        WlrLayershell {
            id: clickOutsideOverlay
            required property ShellScreen modelData

            screen: modelData
            visible: TrayMenuState.activeScreenName === modelData.name
            color: "transparent"
            layer: WlrLayer.Top  // Below Overlay, so popup (which is on Overlay) stays on top
            namespace: "click-outside-overlay"
            keyboardFocus: WlrKeyboardFocus.None

            anchors.top: true
            anchors.bottom: true
            anchors.left: true
            anchors.right: true

            exclusiveZone: 0

            MouseArea {
                anchors.fill: parent
                onClicked: TrayMenuState.clearMenu();
            }
        }
    }
}
