import QtQuick
import "root:/utils"

Text {
    property int size: 10

    color: ThemeColors.base01

    font {
        family: ThemeFontSettings.font
        pointSize: size
    }
}
