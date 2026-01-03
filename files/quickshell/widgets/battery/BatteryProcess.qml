pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower

Singleton {
    readonly property UPowerDevice battery: UPower.devices.values.find(device => device.isLaptopBattery)
    readonly property string percentage: {
        if (UPowerDeviceState.FullyCharged === battery.state)
            return 100;
        return Math.round(battery.percentage * 100);
    }

    readonly property string formattedPercentage: `${percentage}%`
    readonly property bool isCharging: [UPowerDeviceState.Charging, UPowerDeviceState.PendingCharge].includes(battery.state)
}
