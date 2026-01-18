import GLib from "gi://GLib";
import { Gtk } from "ags/gtk4";
import { createPoll } from "ags/time";
import { With } from "gnim";
import { Container } from "../components/container";

const DOT_SIZE = 8;

export const DateWidget = () => {
  const initialDate = GLib.DateTime.new_now_local();

  const dateTime = createPoll(format(initialDate), 1000, () => {
    return format(GLib.DateTime.new_now_local());
  });

  function format(date: GLib.DateTime) {
    return {
      date: date.format("%a %b %e") as string,
      time: date.format("%H:%M") as string,
    };
  }

  return (
    <box>
      <With value={dateTime}>
        {({ date, time }) => (
          <Container
            className="date-widget"
            rightContainerSpacing={8}
            leftIcon={<label class="text-icon" label="󰸗" />}
            content={[
              <label label={date} />,
              <box
                class="dot"
                heightRequest={DOT_SIZE}
                widthRequest={DOT_SIZE}
                valign={Gtk.Align.CENTER}
              />,
              <label label={time} />,
            ]}
          />
        )}
      </With>
    </box>
  );
};
