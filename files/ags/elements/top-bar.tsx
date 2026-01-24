import { Astal, type Gdk } from "ags/gtk4";
import app from "ags/gtk4/app";
import { BAR_HEIGHT } from "../config";
import { ActiveWindowWidget } from "../widgets/active-window-widget";
import { BatteryWidget } from "../widgets/battery-widget";
import { DateWidget } from "../widgets/date-widget";
import { setShellWindow } from "../widgets/frame-drawing";
import { TrayWidget } from "../widgets/tray-widget";
import { VolumeWidget } from "../widgets/volume-widget";
import { WifiWidget } from "../widgets/wifi-widget";

const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;

export const TopBar = (gdkmonitor: Gdk.Monitor) => {
  return (
    <window
      visible
      name="window-top-bar"
      class="window-top-bar"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP | LEFT | RIGHT}
      application={app}
      $={(self) => {
        setShellWindow(self);
      }}
    >
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
    </window>
  );
};
