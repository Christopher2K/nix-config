import QtQuick
import Quickshell
import Niri

Niri {
    id: root
    Component.onCompleted: connect()
    onConnected: console.log("Connected to Niri")
    onErrorOccurred: error => console.error("Error: ", error)

    property var focusedWindowEntry: niri.focusedWindow ? DesktopEntries.byId(niri.focusedWindow.appId) : null
}
