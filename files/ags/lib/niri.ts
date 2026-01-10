import { subprocess } from "ags/process";
import type { NiriEventHandler, NiriSubscription } from "./niri.types";

export * from "./niri.types";

export function subscribeToNiri(handler: NiriEventHandler): NiriSubscription {
  const proc = subprocess({
    cmd: ["niri", "msg", "--json", "event-stream"],
    out: (line) => {
      try {
        const eventData = JSON.parse(line);
        const eventName = Object.keys(eventData)[0];
        const eventValue = eventData[eventName];

        handler({ name: eventName, value: eventValue });
      } catch (e) {
        console.error("Failed to parse Niri event:", e);
      }
    },
    err: (err) => console.error("Niri event-stream error:", err),
  });

  return {
    stop() {
      proc.kill();
    },
  };
}
