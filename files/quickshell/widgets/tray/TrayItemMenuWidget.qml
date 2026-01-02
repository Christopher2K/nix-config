import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import "root:/utils"

Item {
    id: root
    property SystemTrayItem trayItemData
    property string screenName

    readonly property bool shouldBeVisible: TrayMenuState.activeItemIcon === root.trayItemData.icon && TrayMenuState.activeScreenName === root.screenName

    QsMenuOpener {
        id: menuOpener
        menu: root.trayItemData.menu
    }

    PopupWindow {
        id: popup
        anchor.item: root.parent
        anchor.rect.x: 0
        anchor.rect.y: root.parent.height + 16
        visible: shouldBeVisible
        implicitWidth: content.width
        implicitHeight: content.height
        color: "transparent"

        Rectangle {
            id: content
            color: ThemeColors.background
            implicitWidth: wrapper.width
            implicitHeight: wrapper.height
            radius: 8
            border.color: ThemeColors.base05
            border.width: 2

            Item {
                id: wrapper
                implicitWidth: column.width + 16
                implicitHeight: column.height + 16

                ColumnLayout {
                    id: column
                    anchors.centerIn: parent
                    spacing: 0

                    Repeater {
                        model: menuOpener.children

                        Loader {
                            id: loader
                            required property QsMenuEntry modelData
                            sourceComponent: modelData.isSeparator ? separatorMenuEntry : regularMenuEntry
                            Layout.fillWidth: true

                            Binding {
                                target: loader.item
                                property: "entry"
                                value: loader.modelData
                                when: loader.status === Loader.Ready
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: regularMenuEntry

        MouseArea {
            id: mouseArea
            property QsMenuEntry entry
            property color backgroundColor: mouseArea.containsMouse ? ThemeColors.base05 : "transparent"
            property color textColor: mouseArea.containsMouse ? ThemeColors.base00 : ThemeColors.base05

            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton
            onClicked: () => {
                modelData.triggered();
                TrayMenuState.clearMenu();
            }
            implicitWidth: text.implicitWidth
            implicitHeight: text.implicitHeight

            Rectangle {
                id: content
                anchors.fill: parent
                color: mouseArea.backgroundColor
                radius: 4

                Text {
                    id: text

                    topPadding: 4
                    bottomPadding: 4
                    leftPadding: 8
                    rightPadding: 8
                    color: mouseArea.textColor
                    font {
                        family: ThemeColors.font
                        pointSize: ThemeColors.fontSize
                    }
                    text: modelData.text
                }
            }
        }
    }

    Component {
        id: separatorMenuEntry

        Item {
            id: wrapper
            property QsMenuEntry entry
            implicitWidth: 20
            implicitHeight: separator.height + 16

            Rectangle {
                id: separator
                anchors.centerIn: parent
                width: parent.width - 16
                height: 2
                color: ThemeColors.base07
                radius: 999
            }
        }
    }
}
