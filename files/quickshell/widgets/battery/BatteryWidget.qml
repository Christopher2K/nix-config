import QtQuick
import Quickshell.Services.UPower
import "root:/utils"

CustomBackground {
    id: root
    property var icon: {
        const value = BatteryProcess.percentage;
        console.log("Charging", UPowerDeviceState.Discharging);
        if (BatteryProcess.isCharging) {
            return "󰂄";
        }

        const iconsByConditions = [[value <= 100 && value > 80, ""], [value <= 80 && value > 50, ""], [value <= 50 && value > 25, ""], [value <= 25 && value > 10, ""], [value <= 10 && value >= 0, ""],];
        return iconsByConditions.find(icon => icon[0])[1];
    }

    containerWidth: row.width + 16

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 4

        Icon {
            anchors.verticalCenter: parent.verticalCenter
            icon: root.icon
            color: "#41cc54"
            size: 14

        }

        CustomText {
            anchors.verticalCenter: parent.verticalCenter
            text: BatteryProcess.formattedPercentage
            size: 8
            font.bold: true
        }
    }
}
