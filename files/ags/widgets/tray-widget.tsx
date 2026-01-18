import Tray from "gi://AstalTray";
import { Gdk, Gtk } from "ags/gtk4";
import { createBinding, For } from "gnim";
import { Container } from "../components/container";

const ICON_SIZE = 20;

export const TrayWidget = () => {
  const tray = Tray.get_default();
  const trayItems = createBinding(tray, "items");

  return (
    <Container
      content={
        <box class="tray-widget" spacing={8} vexpand>
          <For each={trayItems}>{(item) => <TrayItemWidget item={item} />}</For>
        </box>
      }
    />
  );
};

const TrayItemWidget = ({ item }: { item: Tray.TrayItem }) => {
  const icon = createBinding(item, "gicon");
  let popoverMenuRef: Gtk.PopoverMenu | null = null;
  const menuModel = createBinding(item, "menuModel");

  return (
    <box
      class="tray-item"
      $={(self) => {
        self.insert_action_group("dbusmenu", item.actionGroup);
      }}
    >
      <button
        $={(self) => {
          const rightClick = new Gtk.GestureClick();
          rightClick.set_button(Gdk.BUTTON_SECONDARY);
          rightClick.connect("pressed", () => popoverMenuRef?.popup());
          self.add_controller(rightClick);
        }}
        onClicked={() => item.activate(0, 0)}
      >
        <image gicon={icon} pixelSize={ICON_SIZE} />
      </button>
      <Gtk.PopoverMenu
        $={(self) => {
          popoverMenuRef = self;
        }}
        menuModel={menuModel}
        hasArrow={false}
      />
    </box>
  );
};
