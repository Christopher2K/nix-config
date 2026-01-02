import Quickshell
import Quickshell.Io
import QtQuick
import "root:/utils"
import "./widgets/clock"
import "./widgets/tray"
import "./widgets/battery"

Scope {
    id: root
    property string time

    readonly property int barHeight: 40

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

            implicitHeight: root.barHeight 

            Rectangle {
                anchors.fill: parent
                radius: 999
                color: Qt.alpha(ThemeColors.background, 0.95)

                Row {
                    anchors.fill: parent
                    layoutDirection: Qt.RightToLeft

                    rightPadding: 10
                    leftPadding: 10
                    spacing: 10

                    BatteryWidget {
                        anchors.verticalCenter: parent.verticalCenter
                    }

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
