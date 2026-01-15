{ pkgs, configDest, ... }:
let
  monitors = {
    builtin-laptop = "Samsung Display Corp. ATNA60DL04-0  Unknown";
    lg-home = "LG Electronics LG ULTRAGEAR+ 406NTWGBQ649";
    capture-card = "Elgato Systems LLC HD60 X Unknown";
  };

  get-output-by-description = pkgs.writeShellScriptBin "get-output-by-description" ''
    set -euo pipefail

    if [ -z "''${1:-}" ]; then
      echo "Usage: get-output-by-description <description>" >&2
      exit 1
    fi

    description="$1"

    output=$(${pkgs.niri}/bin/niri msg -j outputs | ${pkgs.jq}/bin/jq -r --arg desc "$description" '
      to_entries[] |
      select(
        ((.value.make + " " + .value.model + " " + (.value.serial // "Unknown")) | gsub("\\s+"; " ") | gsub("^ | $"; "")) 
        == 
        ($desc | gsub("\\s+"; " ") | gsub("^ | $"; ""))
      ) | .key
    ')

    if [ -z "$output" ]; then
      echo "Error: No output found matching description: $description" >&2
      exit 1
    fi

    echo "$output"
  '';
  mirror-command = "exec wl-present mirror $(${get-output-by-description}/bin/get-output-by-description \"${monitors.builtin-laptop}\") --fullscreen-output $(${get-output-by-description}/bin/get-output-by-description \"${monitors.capture-card}\") --fullscreen";
  base-command = "exec pkill -i wl-mirror";
in
{
  home.packages = with pkgs; [
    wl-mirror
    get-output-by-description
  ];

  services.kanshi = {
    enable = true;
    systemdTarget = "graphical-session.target";
    settings = [
      {
        profile.name = "undocked";
        profile.exec = base-command;
        profile.outputs = [
          {
            criteria = monitors.builtin-laptop;
            scale = 1.25;
            mode = "2560x1600@240";
          }
        ];
      }
      {
        profile.name = "docked";
        profile.exec = base-command;
        profile.outputs = [
          {
            criteria = monitors.builtin-laptop;
            scale = 1.5;
            mode = "2560x1600@240";
            position = "-1707,0";
          }
          {
            criteria = monitors.lg-home;
            scale = 1.0;
            mode = "2560x1440@120";
            position = "0,0";
          }
        ];
      }
      {
        profile.name = "capture";
        profile.exec = mirror-command;
        profile.outputs = [
          {
            criteria = monitors.builtin-laptop;
            scale = 1.0;
            mode = "1600x1200@240";
            position = "0,0";
          }
          {
            criteria = monitors.capture-card;
            scale = 1.0;
            mode = "2560x1440@59.951";
            position = "10000,10000";
          }
        ];
      }
    ];
  };
}
