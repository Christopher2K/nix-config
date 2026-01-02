import QtQuick
import "root:/utils"

Rectangle {
    color: ThemeColors.base06
    implicitHeight: row.implicitHeight
    implicitWidth: row.implicitWidth
    radius: 999

    component ClockText: CustomText {
        id: label

        topPadding: 4
        bottomPadding: 4
        leftPadding: 8
        rightPadding: 8
    }

    Row {
        id: row
        spacing: 4

        ClockText {
            text: ClockProcess.date
        }

        Rectangle {
            readonly property double size: 8

            anchors.verticalCenter: parent.verticalCenter
            implicitHeight: size
            implicitWidth: size
            color: ThemeColors.base01
            radius: size
        }

        ClockText {
            font.bold: true
            text: ClockProcess.time
        }
    }
}
