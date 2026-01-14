import Tray from "gi://AstalTray";
import { Gdk, Gtk } from "ags/gtk4";
import { createBinding, For } from "gnim";
import { Container } from "../common/container";

const ICON_SIZE = 20;

export const TrayWidget = () => {
  const tray = Tray.get_default();
  const trayItems = createBinding(tray, "items");

  return (
    <Container>
      <box class="tray-widget" spacing={8} vexpand>
        <For each={trayItems}>
          {(item) => {
            const icon = createBinding(item, "gicon");
            let popoverRef: Gtk.Popover | null = null;

            return (
              <box>
                <button
                  class="tray-item"
                  $={(self) => {
                    const rightClick = new Gtk.GestureClick();
                    rightClick.set_button(Gdk.BUTTON_SECONDARY);
                    rightClick.connect("pressed", () => popoverRef?.popup());
                    self.add_controller(rightClick);
                  }}
                  onClicked={() => item.activate(0, 0)}
                >
                  <image gicon={icon} pixelSize={ICON_SIZE} />
                </button>
                <popover
                  position={Gtk.PositionType.BOTTOM}
                  hasArrow={false}
                  $={(self) => {
                    popoverRef = self;
                  }}
                >
                  <label label="Hello world" />
                </popover>
              </box>
            );
          }}
        </For>
      </box>
    </Container>
  );
};
