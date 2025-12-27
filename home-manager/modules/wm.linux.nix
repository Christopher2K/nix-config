{
  config,
  inputs,
  pkgs,
  src,
  configDest,
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
  ############
  # Hyprland #
  ############
  # Specifics are configured at system level
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    settings = {
      # Variables
      "$terminal" = "ghostty";
      "$fileManager" = "dolphin";
      "$menu" = "hyprlauncher";
      "$webBrowser" = "firefox";
      "$mainMod" = "SUPER";

      # Autostart
      exec-once = [
        "$terminal"
        "~/scripts/touchpad-typing-guard.sh"
        "ags run"
      ];

      # Environment variables
      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "WLR_NO_HARDWARE_CURSORS,1"
      ];

      # General settings
      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      # Decoration
      decoration = {
        rounding = 10;
        rounding_power = 2;
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      # Animations
      animations = {
        enabled = "yes";

        bezier = [
          "easeOutQuint, 0.23, 1, 0.32, 1"
          "easeInOutCubic, 0.65, 0.05, 0.36, 1"
          "linear, 0, 0, 1, 1"
          "almostLinear, 0.5, 0.5, 0.75, 1"
          "quick, 0.15, 0, 0.1, 1"
        ];

        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
          "zoomFactor, 1, 7, quick"
        ];
      };

      # Dwindle layout
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # Master layout
      master = {
        new_status = "master";
      };

      # Misc
      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = false;
      };

      # Input
      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "caps:escape";
        kb_rules = "";
        follow_mouse = 1;
        sensitivity = 0;

        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
        };
      };

      # Gestures
      gesture = "3, horizontal, workspace";

      # Per-device config
      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };

      # Keybindings
      bind = [
        "$mainMod, Q, killactive,"
        "$mainMod, B, exec, $webBrowser"
        "$mainMod, RETURN, exec, $terminal"
        "$mainMod, M, exec, command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, V, togglefloating,"
        "$mainMod, SPACE, exec, $menu"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"

        # Move focus with arrow keys
        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move active window to workspace
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Special workspace (scratchpad)
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
      ];

      # Mouse bindings
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # Media keys (allow repeat)
      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      # Media keys (locked, no repeat)
      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      # Debug
      debug = {
        disable_logs = false;
        enable_stdout_logs = true;
      };
    };
    extraConfig = ''
      # Source the auto-generated monitors configuration
      source = ~/.config/hypr/monitors.conf

      windowrule {
          # Ignore maximize requests from all apps. You'll probably like this.
          name = suppress-maximize-events
          match:class = .*

          suppress_event = maximize
      }

      windowrule {
          # Fix some dragging issues with XWayland
          name = fix-xwayland-drags
          match:class = ^$
          match:title = ^$
          match:xwayland = true
          match:float = true
          match:fullscreen = false
          match:pin = false

          no_focus = true
      }

      # Hyprland-run windowrule
      windowrule {
          name = move-hyprland-run

          match:class = hyprland-run

          move = 20 monitor_h-120
          float = yes
      }

    '';
  };

  ######################
  # HyprDynaicMonitors #
  ######################
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

  ################
  # Hyprlauncher #
  ################
  services.hyprlauncher = {
    enable = true;
    settings = { };
  };

  ##############
  # Hyprpaper #
  ##############
  home.file."${configDest "wallpapers"}" = {
    source = src "wallpapers";
    recursive = true;
  };

  services.hyprpaper = {
    enable = true;

    settings = {
      ipc = "on";
      preload = [
        "~/.config/wallpapers/wallpaper-1.jpg"
        "~/.config/wallpapers/wallpaper-2.jpg"
      ];
      wallpaper = [
        ",~/.config/wallpapers/wallpaper-1.jpg"
      ];
    };
  };

  ###########
  # Widgets #
  ###########
  home.file."${configDest "ags"}".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/files/ags";
  programs.ags.enable = true;

  #######
  # GTK #
  #######
  gtk = {
    enable = true;
    theme.package = pkgs.gruvbox-gtk-theme;
    theme.name = "Gruvbox-Dark";
  };
}
