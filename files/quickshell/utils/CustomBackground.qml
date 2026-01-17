import QtQuick
import "root:/utils"

Rectangle {
    property real containerWidth: 0
    property real containerHeight: {
        Values.contentHeight - Values.barVerticalPadding * 2;
    }

    color: ThemeColors.base06
    radius: 999
    implicitWidth: containerWidth + 16
    implicitHeight: containerHeight
}
