import GLib from "gi://GLib";
import { Gtk } from "ags/gtk4";
import { createPoll } from "ags/time";
import { Container } from "../common/container";

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
    <Container
      className="date-widget"
      rightContainerSpacing={8}
      left={<label class="text-icon" label="󰸗" />}
    >
      <label label={dateTime().date} />
      <box
        class="dot"
        heightRequest={DOT_SIZE}
        widthRequest={DOT_SIZE}
        valign={Gtk.Align.CENTER}
      />
      <label label={dateTime().time} />
    </Container>
  );
};
