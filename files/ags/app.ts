import app from "ags/gtk4/app";
import { TopBar } from "./elements/top-bar";
import style from "./style.scss";

app.start({
  css: style,
  main() {
    app.get_monitors().map(TopBar);
  },
});
