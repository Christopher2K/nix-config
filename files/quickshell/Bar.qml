import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "root:/utils"
import "./widgets/audio"
import "./widgets/battery"
import "./widgets/clock"
import "./widgets/tray"
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

            anchors.top: true
            anchors.left: true
            anchors.right: true

            implicitHeight: root.barHeight

            Item {
                id: barContainer
                anchors.fill: parent

                property color fillColor: ThemeColors.background
                property real cornerRadius: 32
                property real mainHeight: 48

                // Main bar rectangle (40px height)
                Rectangle {
                    id: mainBar
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    height: barContainer.mainHeight
                    color: barContainer.fillColor
                }

                // Left inverted corner
                Canvas {
                    id: leftCorner
                    anchors.left: parent.left
                    anchors.top: mainBar.bottom
                    width: 40
                    height: 32

                    onPaint: {
                        var ctx = getContext("2d")
                        const r = barContainer.cornerRadius
                        ctx.clearRect(0, 0, r, r)

                        // Fill the square
                        ctx.fillStyle = barContainer.fillColor
                        ctx.fillRect(0, 0, r, r)

                        // Cut out the circle to create inverted corner
                        ctx.globalCompositeOperation = "destination-out"
                        ctx.beginPath()
                        ctx.arc(r, r, r, Math.PI, 1.5 * Math.PI)
                        ctx.lineTo(r, r)
                        ctx.closePath()
                        ctx.fill()
                    }

                    Component.onCompleted: requestPaint()
                }

                // Right inverted corner
                Canvas {
                    id: rightCorner
                    anchors.right: parent.right
                    anchors.top: mainBar.bottom
                    width: barContainer.cornerRadius
                    height: barContainer.cornerRadius

                    onPaint: {
                        var ctx = getContext("2d")
                        var r = barContainer.cornerRadius
                        ctx.clearRect(0, 0, r, r)

                        // Fill the square
                        ctx.fillStyle = barContainer.fillColor
                        ctx.fillRect(0, 0, r, r)

                        // Cut out the circle to create inverted corner
                        ctx.globalCompositeOperation = "destination-out"
                        ctx.beginPath()
                        ctx.arc(0, r, r, 1.5 * Math.PI, 2 * Math.PI)
                        ctx.lineTo(0, r)
                        ctx.closePath()
                        ctx.fill()
                    }

                    Component.onCompleted: requestPaint()
                }
            }

            FlexboxLayout {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: barContainer.mainHeight
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

                    SoundOutputWidget {}

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
