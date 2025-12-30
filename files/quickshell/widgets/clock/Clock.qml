import QtQuick
import "../../"

Rectangle {
    color: Constants.base06
    implicitHeight: row.implicitHeight
    implicitWidth: row.implicitWidth
    radius: 999

    Row {
        id: row
        spacing: 4

        Text {
            id: label
            topPadding: 4
            bottomPadding: 4
            leftPadding: 8
            rightPadding: 8
            color: Constants.base01

            font {
                family: Constants.font
                pointSize: Constants.fontSize
            }
            text: ClockProcess.date
        }

        Rectangle {
            readonly property double size: 8

            anchors.verticalCenter: parent.verticalCenter
            implicitHeight: size
            implicitWidth: size
            color: Constants.base01
            radius: size
        }

        Text {
            id: label2

            topPadding: 4
            bottomPadding: 4
            leftPadding: 8
            rightPadding: 8

            color: Constants.base01

            font {
                family: Constants.font
                pointSize: Constants.fontSize
                bold: true
            }
            text: ClockProcess.time
        }
    }
}
