import Tray from "gi://AstalTray";
import { createBinding, For } from "gnim";
import { Container } from "../common/container";

const ICON_SIZE = 20;

export const TrayWidget = () => {
  const tray = Tray.get_default();
  const trayItems = createBinding(tray, "items");

  return (
    <Container>
      <box class="tray-widget-root" spacing={8}>
        <For each={trayItems}>
          {(item) => {
            return <image gicon={item.gicon} pixelSize={ICON_SIZE} />;
          }}
        </For>
      </box>
    </Container>
  );
};
