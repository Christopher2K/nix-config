import QtQuick
import "root:/utils"

CustomBackground {
    containerWidth: row.implicitWidth

    component ClockText: CustomText {
        id: label

        topPadding: 4
        bottomPadding: 4
        leftPadding: 8
        rightPadding: 8
    }

    Row {
        id: row
        anchors.centerIn: parent
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
