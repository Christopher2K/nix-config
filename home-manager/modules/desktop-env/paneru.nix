{ inputs, ... }:

{
  imports = [
    inputs.paneru.homeModules.paneru
  ];

  services.paneru = {
    enable = false;
    settings = {
      options = {
        focus_follows_mouse = false;
        mouse_follows_focus = false;
        preset_column_widths = [
          0.33
          0.5
          0.75
        ];
        swipe_gesture_fingers = 4;
      };
      bindings = {
        window_focus_west = "cmd - h";
        window_focus_east = "cmd - l";
        window_focus_north = "cmd - k";
        window_focus_south = "cmd - j";
        window_swap_west = "alt - h";
        window_swap_east = "alt - l";
        window_swap_first = "alt + shift - h";
        window_swap_last = "alt + shift - l";
        window_center = "alt - c";
        window_resize = "alt - r";
        window_fullwidth = "alt - f";
        window_manage = "ctrl + alt - t";
        window_stack = "alt - ]";
        window_unstack = "alt + shift - ]";
        quit = "ctrl + alt - q";
      };
    };
  };
}
