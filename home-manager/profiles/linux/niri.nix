{
  config,
  lib,
  pkgs,
  inputs,
  razerKeyboardSerial,
  ...
}:

{
  imports = [
    inputs.niri.homeModules.niri
  ];

  home.packages = [
    pkgs.xwayland-satellite
  ];

  programs.niri = {
    enable = true;
    package = pkgs.niri;

    settings = {
      debug = {
        render-drm-device = "/dev/dri/amdigpurender";
      };

      spawn-at-startup = [
        {
          argv = [
            "1password"
            "--silent"
          ];
        }
      ];

      prefer-no-csd = true;
      # Input device configuration
      input = {
        keyboard = {
          numlock = true;
          xkb = {
            layout = "us";
            variant = "altgr-intl";
            options = "caps:escape";
          };
        };

        touchpad = {
          tap = true;
          dwt = true;
          natural-scroll = true;
        };

        # Mouse settings (defaults)
        mouse = { };

        # Trackpoint settings (defaults)
        trackpoint = { };
      };

      # Layout settings
      layout = {
        gaps = 16;
        struts =
          let
            verticalStruts = 40;
            horizontalStruts = 16;
          in
          {
            top = verticalStruts;
            bottom = verticalStruts;
            left = horizontalStruts;
            right = horizontalStruts;
          };
        center-focused-column = "never";
        background-color = "transparent";

        preset-column-widths = [
          { proportion = 1.0 / 3.0; }
          { proportion = 1.0 / 2.0; }
          { proportion = 2.0 / 3.0; }
        ];

        default-column-width = {
          proportion = 0.5;
        };

        focus-ring = {
          enable = true;
          active = {
            color = "#7C6F64";
          };
        };

        shadow = {
          enable = false;
        };
      };

      # Hotkey overlay
      hotkey-overlay = { };

      # Screenshot path
      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

      # Window rules
      window-rules = [
        {
          matches = [ ];
          geometry-corner-radius =
            let
              radius = 12.0;
            in
            {
              top-left = radius;
              top-right = radius;
              bottom-left = radius;
              bottom-right = radius;
            };
          clip-to-geometry = true;
        }
      ];

      layer-rules = [
        {
          matches = [ { namespace = "^wpaperd"; } ];
          place-within-backdrop = true;
        }
      ];

      # Keybindings
      binds = {
        # Show hotkey overlay
        "Mod+Shift+Slash".action.show-hotkey-overlay = [ ];

        # Launch programs
        "Mod+Return" = {
          hotkey-overlay.title = "Open ghostty";
          action.spawn = "ghostty";
        };
        "Mod+Space" = {
          hotkey-overlay.title = "Start launcher";
          action.spawn = [
            "vicinae"
            "toggle"
          ];
        };
        "Super+Alt+L" = {
          hotkey-overlay.title = "Lock the Screen: swaylock";
          action.spawn = "swaylock";
        };

        # Volume controls
        "XF86AudioRaiseVolume" = {
          allow-when-locked = true;
          action.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0";
        };
        "XF86AudioLowerVolume" = {
          allow-when-locked = true;
          action.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
        };
        "XF86AudioMute" = {
          allow-when-locked = true;
          action.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };

        # Media controls
        "XF86AudioPlay" = {
          allow-when-locked = true;
          action.spawn-sh = "playerctl play-pause";
        };
        "XF86AudioStop" = {
          allow-when-locked = true;
          action.spawn-sh = "playerctl stop";
        };
        "XF86AudioPrev" = {
          allow-when-locked = true;
          action.spawn-sh = "playerctl previous";
        };
        "XF86AudioNext" = {
          allow-when-locked = true;
          action.spawn-sh = "playerctl next";
        };

        # Brightness controls
        "XF86MonBrightnessUp" = {
          allow-when-locked = true;
          action.spawn-sh = "brightnessctl --device='amdgpu_bl*' set +10%";
        };
        "XF86MonBrightnessDown" = {
          allow-when-locked = true;
          action.spawn-sh = "brightnessctl --device='amdgpu_bl*' set 10%-";
        };

        "XF86KbdBrightnessUp" = {
          allow-when-locked = true;
          action.spawn = [
            "sh"
            "${config.home.homeDirectory}/scripts/razer-kbd-brightness-up.sh"
            razerKeyboardSerial
          ];
        };
        "XF86KbdBrightnessDown" = {
          allow-when-locked = true;
          action.spawn = [
            "sh"
            "${config.home.homeDirectory}/scripts/razer-kbd-brightness-down.sh"
            razerKeyboardSerial
          ];
        };

        # Overview
        "Mod+O" = {
          repeat = false;
          action.toggle-overview = [ ];
        };

        # Close window
        "Mod+Q" = {
          repeat = false;
          action.close-window = [ ];
        };

        "Mod+H".action.focus-column-left = [ ];
        "Mod+J".action.focus-window-down = [ ];
        "Mod+K".action.focus-window-up = [ ];
        "Mod+L".action.focus-column-right = [ ];

        # Move windows (vim keys)
        "Mod+Ctrl+H".action.move-column-left = [ ];
        "Mod+Ctrl+J".action.move-window-down = [ ];
        "Mod+Ctrl+K".action.move-window-up = [ ];
        "Mod+Ctrl+L".action.move-column-right = [ ];

        # First/Last column
        "Mod+Home".action.focus-column-first = [ ];
        "Mod+End".action.focus-column-last = [ ];
        "Mod+Ctrl+Home".action.move-column-to-first = [ ];
        "Mod+Ctrl+End".action.move-column-to-last = [ ];

        # Monitor focus (vim keys)
        "Mod+Shift+H".action.focus-monitor-left = [ ];
        "Mod+Shift+J".action.focus-monitor-down = [ ];
        "Mod+Shift+K".action.focus-monitor-up = [ ];
        "Mod+Shift+L".action.focus-monitor-right = [ ];

        # Move column to monitor (vim keys)
        "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = [ ];
        "Mod+Shift+Ctrl+J".action.move-column-to-monitor-down = [ ];
        "Mod+Shift+Ctrl+K".action.move-column-to-monitor-up = [ ];
        "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = [ ];

        # Workspace navigation
        "Mod+Page_Down".action.focus-workspace-down = [ ];
        "Mod+Page_Up".action.focus-workspace-up = [ ];
        "Mod+U".action.focus-workspace-down = [ ];
        "Mod+I".action.focus-workspace-up = [ ];

        # Move column to workspace
        "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = [ ];
        "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = [ ];
        "Mod+Ctrl+U".action.move-column-to-workspace-down = [ ];
        "Mod+Ctrl+I".action.move-column-to-workspace-up = [ ];

        # Move workspace
        "Mod+Shift+Page_Down".action.move-workspace-down = [ ];
        "Mod+Shift+Page_Up".action.move-workspace-up = [ ];
        "Mod+Shift+U".action.move-workspace-down = [ ];
        "Mod+Shift+I".action.move-workspace-up = [ ];

        # Workspace by number
        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;

        # Move column to workspace by number
        "Mod+Ctrl+1".action.move-column-to-workspace = 1;
        "Mod+Ctrl+2".action.move-column-to-workspace = 2;
        "Mod+Ctrl+3".action.move-column-to-workspace = 3;
        "Mod+Ctrl+4".action.move-column-to-workspace = 4;
        "Mod+Ctrl+5".action.move-column-to-workspace = 5;
        "Mod+Ctrl+6".action.move-column-to-workspace = 6;
        "Mod+Ctrl+7".action.move-column-to-workspace = 7;
        "Mod+Ctrl+8".action.move-column-to-workspace = 8;

        # Column management
        "Mod+BracketLeft".action.consume-or-expel-window-left = [ ];
        "Mod+BracketRight".action.consume-or-expel-window-right = [ ];
        "Mod+Comma".action.consume-window-into-column = [ ];
        "Mod+Period".action.expel-window-from-column = [ ];

        # Window sizing
        "Mod+R".action.switch-preset-column-width = [ ];
        "Mod+Shift+R".action.switch-preset-window-height = [ ];
        "Mod+Ctrl+R".action.reset-window-height = [ ];
        "Mod+F".action.maximize-column = [ ];
        "Mod+Shift+F".action.fullscreen-window = [ ];
        "Mod+Ctrl+F".action.expand-column-to-available-width = [ ];

        # Centering
        "Mod+C".action.center-column = [ ];
        "Mod+Ctrl+C".action.center-visible-columns = [ ];

        # Width/height adjustments
        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";

        # Floating
        "Mod+V".action.toggle-window-floating = [ ];
        "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = [ ];

        # Tabbed display
        "Mod+W".action.toggle-column-tabbed-display = [ ];

        # Screenshots
        "Print".action.screenshot = [ ];
        "Ctrl+Print".action.screenshot-screen = [ ];
        "Alt+Print".action.screenshot-window = [ ];

        # Keyboard shortcuts inhibit toggle
        "Mod+Escape" = {
          allow-inhibiting = false;
          action.toggle-keyboard-shortcuts-inhibit = [ ];
        };

        # Quit
        "Mod+Shift+E".action.quit = [ ];
        "Ctrl+Alt+Delete".action.quit = [ ];

        # Power off monitors
        "Mod+Shift+P".action.power-off-monitors = [ ];
      };
    };
  };
}
