pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root
    property string activeItemIcon: "NONE"
    property string activeScreenName: "NONE"

    function toggleItemMenu(iconId, screenName) {
        if (activeItemIcon === iconId && screenName === activeScreenName) {
            clearMenu();
        } else {
            root.activeScreenName = screenName;
            root.activeItemIcon = iconId;
        }
    }

    function clearMenu() {
        root.activeItemIcon = "NONE";
        root.activeScreenName = "NONE";
    }
}
