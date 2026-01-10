import { Astal, type Gdk } from "ags/gtk4";
import app from "ags/gtk4/app";
import { ActiveWindowWidget } from "./bar-widgets/active-window-widget";
import { TrayWidget } from "./bar-widgets/tray-widget";

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;

  return (
    <window
      visible
      name="bar"
      class="Bar"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP | LEFT | RIGHT}
      application={app}
    >
      <centerbox hexpand vexpand class="barRoot">
        <box $type="start">
          <ActiveWindowWidget />
        </box>

        <box $type="end">
          <TrayWidget />
        </box>
      </centerbox>
    </window>
  );
}
