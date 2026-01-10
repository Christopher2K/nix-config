import AstalApps from "gi://AstalApps";
import { execAsync } from "ags/process";
import { createComputed, createState, onCleanup, onMount, With } from "gnim";
import {
  type NiriFocusedWindow,
  type NiriSubscription,
  subscribeToNiri,
} from "../../lib/niri";

const apps = new AstalApps.Apps();
const appList = apps.get_list();

export const ActiveWindowWidget = () => {
  let subscription: NiriSubscription;
  const [focusedWindow, setFocusedWindow] =
    createState<null | NiriFocusedWindow>(null);

  const focusedApp = createComputed(() => {
    const focusedApp = focusedWindow();
    if (focusedApp === null) return null;

    return appList.find((app) => app.entry.startsWith(focusedApp?.app_id));
  });

  async function updateFocusedWindow() {
    execAsync(["niri", "msg", "--json", "focused-window"]).then((event) => {
      setFocusedWindow(JSON.parse(event) as NiriFocusedWindow);
    });
  }

  onMount(() => {
    updateFocusedWindow();
    subscription = subscribeToNiri((event) => {
      if (event.name === "WindowFocusChanged") {
        updateFocusedWindow();
      }
    });
  });

  onCleanup(() => {
    subscription.stop();
  });

  return (
    <With value={focusedApp}>
      {(app) => {
        if (app == null) return null;

        return (
          <box class="active-window-widget" spacing={0} vexpand>
            <image
              class="window-icon"
              icon_name={app.iconName}
              pixel_size={24}
            />
            <box class="window-title">{app.name}</box>
          </box>
        );
      }}
    </With>
  );
};
