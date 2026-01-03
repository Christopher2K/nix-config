import QtQuick
import Quickshell
import Niri

Niri {
    id: root
    Component.onCompleted: connect()
    onConnected: console.log("Connected to Niri")
    onErrorOccurred: error => console.error("Error: ", error)

    property DesktopEntry focusedWindowEntry: DesktopEntries.byId(niri.focusedWindow.appId)
}
