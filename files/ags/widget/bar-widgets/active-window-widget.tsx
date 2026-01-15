import AstalApps from "gi://AstalApps";
import { execAsync } from "ags/process";
import { createComputed, createState, onCleanup, onMount, With } from "gnim";
import {
  type NiriFocusedWindow,
  type NiriSubscription,
  subscribeToNiri,
} from "../../lib/niri";
import { Container } from "../common/container";

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
      if (
        event.name === "WindowFocusChanged" ||
        event.name === "WindowOpenedOrChanged"
      ) {
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
        if (app == null) return <box />;

        return (
          <Container
            className="active-window-widget"
            left={<image icon_name={app.iconName} pixel_size={24} />}
          >
            <label label={app.name} />
          </Container>
        );
      }}
    </With>
  );
};
