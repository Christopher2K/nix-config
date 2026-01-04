import QtQuick
import Quickshell.Services.UPower
import "root:/utils"

IconWithLabel {
    id: root
    icon: {
        const value = BatteryProcess.percentage;
        if (BatteryProcess.isCharging) {
            return "󰂄";
        }

        const iconsByConditions = [[value <= 100 && value > 80, ""], [value <= 80 && value > 50, ""], [value <= 50 && value > 25, ""], [value <= 25 && value > 10, ""], [value <= 10 && value >= 0, ""],];
        return iconsByConditions.find(icon => icon[0])[1];
    }
    iconColor: "#41cc54"
    label: BatteryProcess.formattedPercentage
}
