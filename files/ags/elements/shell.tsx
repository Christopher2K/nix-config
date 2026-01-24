import { Astal, type Gdk, Gtk } from "ags/gtk4";
import app from "ags/gtk4/app";
import { setShellWindow } from "../widgets/frame-drawing";
import { TopBar } from "./top-bar";

const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;

export const Shell = (gdkmonitor: Gdk.Monitor) => {
  return (
    <window
      visible
      name="shell"
      class="shell"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.IGNORE}
      anchor={TOP | LEFT | RIGHT}
      application={app}
      $={(self) => {
        setShellWindow(self);
      }}
    >
      <TopBar />
    </window>
  );
};
