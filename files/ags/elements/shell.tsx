import { Astal, type Gdk, Gtk } from "ags/gtk4";
import app from "ags/gtk4/app";
import {
  BAR_HEIGHT,
  EDGE_WIDTH,
  FrameDrawing,
  setShellWindow,
} from "../widgets/frame-drawing";
import { TopBar } from "./top-bar";

const { TOP, BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor;
const { VERTICAL, HORIZONTAL } = Gtk.Orientation;

export const Shell = (gdkmonitor: Gdk.Monitor) => {
  return (
    <window
      visible
      name="shell"
      class="shell"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.IGNORE}
      anchor={TOP | BOTTOM | LEFT | RIGHT}
      application={app}
      $={(self) => {
        setShellWindow(self);
      }}
    >
      <overlay>
        {/* Base layer: Cairo drawing for frame + input region */}
        <FrameDrawing />

        {/* Overlay: UI content (bars) */}
        <box
          $type="overlay"
          hexpand
          vexpand
          orientation={VERTICAL}
          canTarget={false}
          canFocus={false}
        >
          <TopBar />

          {/* Middle section */}
          <box hexpand vexpand orientation={HORIZONTAL}>
            {/* Left edge - clickable */}
            <box
              vexpand
              class="shell-edge left-edge"
              width_request={EDGE_WIDTH}
              canTarget={true}
            />

            {/* Transparent middle - non-interactive */}
            <box vexpand hexpand canTarget={false} canFocus={false} />

            {/* Right edge - clickable */}
            <box
              vexpand
              class="shell-edge right-edge"
              width_request={EDGE_WIDTH}
              canTarget={true}
            />
          </box>

          {/* Bottom bar */}
          <box
            hexpand
            class="shell-bar bottom-bar"
            height_request={BAR_HEIGHT}
            canTarget={true}
          ></box>
        </box>
      </overlay>
    </window>
  );
};
