import app from "ags/gtk4/app";
import { Shell } from "./elements/shell";
import style from "./style.scss";

app.start({
  css: style,
  main() {
    app.get_monitors().map(Shell);
  },
});
