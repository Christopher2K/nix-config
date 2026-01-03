import Quickshell
import QtQuick
import Qt5Compat.GraphicalEffects
import "root:/utils"

Row {
    id: root
    NiriProcess {
        id: niri
    }
    visible: niri.focusedWindowEntry != null

    property string appLabel: {
        if (niri.focusedWindowEntry == null)
            return "";
        return `${niri.focusedWindowEntry.name}`;
    }
    spacing: 0

    CustomBackground {
        containerWidth: icon.width
        topRightRadius: 0
        bottomRightRadius: 0
        color: ThemeColors.base05

        Image {
            id: icon
            anchors.centerIn: parent
            source: Quickshell.iconPath(niri.focusedWindowEntry.icon)
            width: 28
            height: 28
            visible: false
        }

        Desaturate {
            anchors.fill: icon
            source: icon
            desaturation: 1
        }
    }

    CustomBackground {
        containerWidth: text.width + 16
        topLeftRadius: 0
        bottomLeftRadius: 0
        CustomText {
            id: text
            anchors.centerIn: parent
            text: appLabel
        }
    }
}
