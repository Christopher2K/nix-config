import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

// Control {
//     anchors.centerIn: parent.verticalCenter
//
//     background: Rectangle {
//         color: ThemeColors.base0F
//         radius: 999
//     }
//     contentItem: Row { 
//         Text {
//             text: "Hello"
//         }
//     }
// }

Item {
    id: root
    property var icon

    anchors.centerIn: parent.verticalCenter
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    implicitWidth: row.width
    // implicitHeight: parent.height

    Row {
        id: row

        Loader {
            active: icon !== null

            sourceComponent: Rectangle {
                implicitWidth: leftIcon.width
                implicitHeight: leftIcon.height

                topLeftRadius: 999
                bottomLeftRadius: 999
                topRightRadius: icon ===  null ? 999 : 0 
                bottomRightRadius: icon === null ? 999 : 0 

                Icon {
                    id: leftIcon
                    icon: root.icon
                    size: 14
                }
            }
        }

        Rectangle {
            implicitWidth: text.width
            implicitHeight: text.height
            color: ThemeColors.base0F

            topRightRadius: 999
            bottomRightRadius: 999

            topLeftRadius: icon ===  null ? 999 : 0 
            bottomLeftRadius: icon === null ? 999 : 0 

            Text {
                id: text
                text: "Hello world"
            }
        }
    }
}
