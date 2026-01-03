import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "root:/utils"
import "./widgets/clock"
import "./widgets/tray"
import "./widgets/battery"
import "./widgets/workspaces"

Scope {
    id: root
    property string time

    readonly property int barHeight: Values.barHeight

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

                FlexboxLayout {
                    anchors.fill: parent
                    justifyContent: FlexboxLayout.JustifySpaceBetween
                    alignItems: FlexboxLayout.AlignCenter

                    Row {
                        rightPadding: 8
                        leftPadding: 8
                        spacing: 8

                        WorkspacesWidget {}
                        FocusedWindowWidget {}
                    }

                    Row {
                        rightPadding: 8
                        leftPadding: 8
                        spacing: 8

                        BatteryWidget {
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        ClockWidget {
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        TrayWidget {
                            screen: barWindow.modelData
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }
        }
    }
}
