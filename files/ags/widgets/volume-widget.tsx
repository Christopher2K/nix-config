import AstalWp from "gi://AstalWp";
import { createBinding, createComputed, createState, With } from "gnim";
import { Container } from "../components/container";

export const VolumeWidget = () => {
  const [defaultSpeaker, setDefaultSpeaker] =
    createState<AstalWp.Endpoint | null>(null);

  AstalWp.get_default().connect("ready", (Wp) => {
    setDefaultSpeaker(Wp.default_speaker);
  });
  AstalWp.get_default().connect("notify::default-speaker", (Wp) => {
    setDefaultSpeaker(Wp.default_speaker);
  });

  return (
    <box>
      <With value={defaultSpeaker}>
        {(speaker) => {
          if (speaker == null) return false;

          const volume = createBinding(speaker, "volume");
          const mute = createBinding(speaker, "mute");
          const formattedVolume = createComputed(() => {
            return `${Math.round(volume() * 100)}%`;
          });

          const icon = createComputed(() => {
            if (mute() || formattedVolume() === "0%") return "";
            if (volume() > 0.5) return "";
            return "";
          });

          console.log("JUST RENDER MY SHIT BRO");

          return (
            <Container
              className="volume-widget"
              leftIcon={<label class="text-icon" label={icon} />}
              content={<label label={formattedVolume} />}
            />
          );
        }}
      </With>
    </box>
  );
};
