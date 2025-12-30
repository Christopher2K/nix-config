import Quickshell
import Quickshell.Io
import QtQuick
import "./widgets/clock"

Scope {
    id: root
    property string time

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData
            color: "transparent" 

            margins.top: 16
            margins.right: 16
            margins.left: 16

            anchors.top: true
            anchors.left: true
            anchors.right: true

            implicitHeight: Constants.barHeight

            Rectangle {
                anchors.fill: parent
                radius: 999
                color: Qt.alpha(Constants.base01, 0.95)
                antialiasing: true

                Row {
                    anchors.fill: parent

                    rightPadding: 10
                    leftPadding: 10

                    Clock {
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }
}
