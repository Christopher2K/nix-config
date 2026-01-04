import QtQuick

CustomBackground {
    id: root

    property string label
    property string icon
    property color iconColor: ThemeColors.base00

    containerWidth: row.width + 16

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 4

        Icon {
            anchors.verticalCenter: parent.verticalCenter
            icon: root.icon
            color: root.iconColor
            size: 14
        }

        CustomText {
            anchors.verticalCenter: parent.verticalCenter
            text: root.label
            size: 8
            font.bold: true
        }
    }
}
