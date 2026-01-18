import AstalWp from "gi://AstalWp";
import { createBinding, createComputed, With } from "gnim";
import { Container } from "../components/container";

export const VolumeWidget = () => {
  const speakers = createBinding(AstalWp.get_default().audio, "speakers");
  const defaultSpeaker = createComputed(() => {
    const speaker = speakers().find((speaker) => speaker.is_default);
    return speaker ?? null;
  });

  return (
    <box>
      <With value={defaultSpeaker}>
        {(speaker) => {
          if (speaker == null) return null;

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
