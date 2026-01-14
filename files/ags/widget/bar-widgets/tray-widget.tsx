import Tray from "gi://AstalTray";
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

            return <image gicon={icon} pixelSize={ICON_SIZE} />;
          }}
        </For>
      </box>
    </Container>
  );
};
