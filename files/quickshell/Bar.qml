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
                property color borderColor: ThemeColors.base04
                property real cornerRadius: 32
                property real mainHeight: 48
                property real borderWidth: 4

                // Main bar rectangle (48px height)
                Rectangle {
                    id: mainBar
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    height: barContainer.mainHeight
                    color: barContainer.fillColor
                    topLeftRadius: barContainer.cornerRadius
                    topRightRadius: barContainer.cornerRadius
                }

                // Bottom border on main bar (outside)
                Rectangle {
                    anchors.left: leftCorner.right
                    anchors.right: rightCorner.left
                    anchors.top: mainBar.bottom
                    height: barContainer.borderWidth
                    color: barContainer.borderColor
                }

                // Left inverted corner
                Canvas {
                    id: leftCorner
                    anchors.left: parent.left
                    anchors.top: mainBar.bottom
                    width: barContainer.cornerRadius
                    height: barContainer.cornerRadius

                    onPaint: {
                        var ctx = getContext("2d");
                        var r = barContainer.cornerRadius;
                        var bw = barContainer.borderWidth;
                        var segments = 20;
                        var startAngle = Math.PI;
                        var endAngle = 1.5 * Math.PI;
                        var angleStep = (endAngle - startAngle) / segments;

                        ctx.clearRect(0, 0, r, r);

                        // Fill the square with background
                        ctx.fillStyle = barContainer.fillColor.toString();
                        ctx.fillRect(0, 0, r, r);

                        // Cut out the full circle
                        ctx.globalCompositeOperation = "destination-out";
                        ctx.beginPath();
                        ctx.arc(r, r, r, startAngle, endAngle);
                        ctx.lineTo(r, r);
                        ctx.closePath();
                        ctx.fill();

                        // Draw tapered border segments (thick at top, thin at left)
                        ctx.globalCompositeOperation = "source-over";
                        ctx.fillStyle = barContainer.borderColor.toString();
                        for (var i = 0; i < segments; i++) {
                            var t = i / segments;
                            var currentWidth = bw * t;
                            var segStart = startAngle + i * angleStep;
                            var segEnd = segStart + angleStep + 0.01;

                            ctx.beginPath();
                            ctx.arc(r, r, r, segStart, segEnd);
                            ctx.arc(r, r, r - currentWidth, segEnd, segStart, true);
                            ctx.closePath();
                            ctx.fill();
                        }
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
                        var ctx = getContext("2d");
                        var r = barContainer.cornerRadius;
                        var bw = barContainer.borderWidth;
                        var segments = 20;
                        var startAngle = 1.5 * Math.PI;
                        var endAngle = 2 * Math.PI;
                        var angleStep = (endAngle - startAngle) / segments;

                        ctx.clearRect(0, 0, r, r);

                        // Fill the square with background
                        ctx.fillStyle = barContainer.fillColor.toString();
                        ctx.fillRect(0, 0, r, r);

                        // Cut out the full circle
                        ctx.globalCompositeOperation = "destination-out";
                        ctx.beginPath();
                        ctx.arc(0, r, r, startAngle, endAngle);
                        ctx.lineTo(0, r);
                        ctx.closePath();
                        ctx.fill();

                        // Draw tapered border segments
                        ctx.globalCompositeOperation = "source-over";
                        ctx.fillStyle = barContainer.borderColor.toString();
                        for (var i = 0; i < segments; i++) {
                            var t = i / segments;
                            var currentWidth = bw * (1 - t);
                            var segStart = startAngle + i * angleStep;
                            var segEnd = segStart + angleStep + 0.01;

                            ctx.beginPath();
                            ctx.arc(0, r, r, segStart, segEnd);
                            ctx.arc(0, r, r - currentWidth, segEnd, segStart, true);
                            ctx.closePath();
                            ctx.fill();
                        }
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

                    WidgetContainer {
                        icon: ""
                    }
    
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
