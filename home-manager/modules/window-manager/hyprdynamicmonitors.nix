{
  inputs,
  configDest,
  src,
  ...
}:
let
  monitors = {
    laptop = "Samsung Display Corp. ATNA60DL04-0";
    capture-card = "Elgato Systems LLC HD60 X";
    desk = "LG Electronics LG ULTRAGEAR+ 406NTWGBQ649";
  };
in
{
  imports = [
    inputs.hyprdynamicmonitors.homeManagerModules.default
  ];

  home.file."${configDest "hypr-monitors-config"}" = {
    source = src "hypr-monitors-config";
    recursive = true;
  };

  home.hyprdynamicmonitors = {
    enable = true;
    config = ''
      [general]
      destination = "$HOME/.config/hypr/monitors.conf"

      [profiles.laptop]
      config_file = "$HOME/.config/hypr-monitors-config/laptop.conf"

      [[profiles.laptop.conditions.required_monitors]]
      description = "${monitors.laptop}"
      monitor_tag = "monitor0"

      [profiles.capture]
      config_file = "$HOME/.config/hypr-monitors-config/capture.conf"

      [[profiles.capture.conditions.required_monitors]]
      description = "${monitors.laptop}"
      monitor_tag = "monitor0"

      [[profiles.capture.conditions.required_monitors]]
      description = "${monitors.capture-card}"
      monitor_tag = "monitor1"

      [profiles.docked]
      config_file = "$HOME/.config/hypr-monitors-config/docked.conf"

      [[profiles.docked.conditions.required_monitors]]
      description = "${monitors.laptop}"
      monitor_tag = "monitor0"

      [[profiles.docked.conditions.required_monitors]]
      description = "${monitors.desk}"
      monitor_tag = "monitor1"
    '';
  };
}
