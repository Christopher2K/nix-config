import QtQuick

Text {
    required property string icon
    property int size: 14

    font.family: "JetBrainsMono Nerd Font"
    font.pointSize: size
    text: icon
}
