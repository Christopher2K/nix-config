import { BAR_HEIGHT } from "../config";
import { ActiveWindowWidget } from "../widgets/active-window-widget";
import { BatteryWidget } from "../widgets/battery-widget";
import { DateWidget } from "../widgets/date-widget";
import { TrayWidget } from "../widgets/tray-widget";
import { VolumeWidget } from "../widgets/volume-widget";
import { WifiWidget } from "../widgets/wifi-widget";

export const TopBar = () => {
  return (
    <box
      hexpand
      class="shell-bar top-bar"
      height_request={BAR_HEIGHT}
      canTarget={true}
    >
      <centerbox hexpand>
        <box $type="start" vexpand>
          <ActiveWindowWidget />
        </box>

        <box $type="end" vexpand spacing={8}>
          <WifiWidget />
          <VolumeWidget />
          <BatteryWidget />
          <DateWidget />
          <TrayWidget />
        </box>
      </centerbox>
    </box>
  );
};
