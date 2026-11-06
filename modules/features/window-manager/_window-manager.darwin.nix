{ inputs, helpers }:
{ pkgs, config, ... }:
{
  imports = [ inputs.paneru.homeModules.paneru ];

  services.paneru = {
    enable = true;

    settings = {
      options = {
        focus_follows_mouse = true;
        mouse_follows_focus = true;
      };

      # Outer gap: 6px screen padding + 6px per-window padding = 12px at the
      # edges and 12px between adjacent windows (Paneru has no global inner-gap
      # option; gaps between windows come from per-window padding rules).
      padding = {
        top = 6;
        bottom = 6;
        left = 6;
        right = 6;
      };

      # Catch-all rule: 6px padding on each side of every window.
      windows.default = {
        title = ".*";
        horizontal_padding = 6;
        vertical_padding = 6;
      };

      bindings = {
        # Focus
        window_focus_west = "alt - h";
        window_focus_east = "alt - l";
        window_focus_north = "alt - k";
        window_focus_south = "alt - j";
        window_focus_first = "alt + shift - leftarrow";
        window_focus_last = "alt + shift - rightarrow";

        # Move
        window_swap_west = "alt + shift - h";
        window_swap_east = "alt + shift - l";
        window_swap_north = "alt + shift - k";
        window_swap_south = "alt + shift - j";
        window_nextdisplay = "alt + shift - tab";

        # Resize
        window_grow = "alt + shift - equal";
        window_shrink = "alt + shift - minus";
        window_center = "alt - c";
        window_fullwidth = "alt - f";
        window_balance = "alt - b";

        # Layout
        window_manage = "alt - t";

        # Virtual workspaces (rows within a native macOS space)
        window_virtual_north = "alt - k";
        window_virtual_south = "alt - j";
        window_virtualnum_1 = "alt - 1";
        window_virtualnum_2 = "alt - 2";
        window_virtualnum_3 = "alt - 3";
        window_virtualnum_4 = "alt - 4";
        window_virtualnum_5 = "alt - 5";
        window_virtualnum_6 = "alt - 6";
        window_virtualnum_7 = "alt - 7";
        window_virtualmovenum_1 = "alt + shift - 1";
        window_virtualmovenum_2 = "alt + shift - 2";
        window_virtualmovenum_3 = "alt + shift - 3";
        window_virtualmovenum_4 = "alt + shift - 4";
        window_virtualmovenum_5 = "alt + shift - 5";
        window_virtualmovenum_6 = "alt + shift - 6";
        window_virtualmovenum_7 = "alt + shift - 7";

        quit = "ctrl + alt - q";
        restart = "ctrl + alt - r";
      };
    };
  };

  services.jankyborders = {
    enable = true;
    settings = {
      active_color = "0xfffe8019";
      inactive_color = "0x00000000";
      hidpi = true;
      style = "round";
      width = 10.0;
      ax_focus = true;
      blacklist = "idea, studio";
    };
  };
}
