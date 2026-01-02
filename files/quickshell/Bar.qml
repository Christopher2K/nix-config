import Quickshell
import Quickshell.Io
import QtQuick
import "./widgets/clock"
import "./widgets/tray"

Scope {
    id: root
    property string time

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: barWindow
            required property ShellScreen modelData
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
                color: Qt.alpha(Constants.background, 0.95)

                Row {
                    anchors.fill: parent
                    layoutDirection: Qt.RightToLeft

                    rightPadding: 10
                    leftPadding: 10
                    spacing: 10

                    TrayWidget {
                        screen: barWindow.modelData
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    ClockWidget {
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }
}
