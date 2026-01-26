{
  pkgs,
  ...
}:
{
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    attachExistingSession = true;
    layouts = {
      default = {
        layout = {
          _children = [
            {
              default_tab_template = {
                _children = [
                  {
                    pane = {
                      size = 1;
                      borderless = true;
                      plugin = {
                        location = "file:${pkgs.zjstatus}/bin/zjstatus.wasm";
                        format_left = "{mode}#[fg=#7F6E63,bg=#d5c4a1]#[fg=#FFFFFF,bold,bg=#7F6E63] {session} #[fg=#7F6E63,bg=#d5c4a1]{tabs}";
                        format_right = "#[fg=#a89984,bg=#d5c4a1]#[fg=#ffffff,bold,bg=#a89984] {datetime} #[fg=#a89984,bg=#d5c4a1]";
                        format_space = "";

                        border_enabled = "false";
                        border_char = "─";
                        border_format = "#[fg=#a89984]{char}";
                        border_position = "top";

                        hide_frame_for_single_pane = "true";

                        mode_normal = "#[bg=#d5c4a1]";
                        mode_tmux = "#[fg=#af3a03,bg=#d5c4a1]#[fg=#ebdbb2,bold,bg=#af3a03]  #[fg=#af3a03,bg=#d5c4a1]";
                        mode_locked = "#[fg=#af3a03,bg=#d5c4a1]#[fg=#ebdbb2,bold,bg=#af3a03]  #[fg=#af3a03,bg=#d5c4a1]";
                        mode_pane = "#[fg=#458588,bg=#d5c4a1]#[fg=#ebdbb2,bold,bg=#458588] PANE #[fg=#458588,bg=#d5c4a1]";
                        mode_tab = "#[fg=#d79921,bg=#d5c4a1]#[fg=#3c3836,bold,bg=#d79921] TAB #[fg=#d79921,bg=#d5c4a1]";
                        mode_resize = "#[fg=#b16286,bg=#d5c4a1]#[fg=#ebdbb2,bold,bg=#b16286] RESIZE #[fg=#b16286,bg=#d5c4a1]";
                        mode_move = "#[fg=#689d6a,bg=#d5c4a1]#[fg=#ebdbb2,bold,bg=#689d6a] MOVE #[fg=#689d6a,bg=#d5c4a1]";
                        mode_scroll = "#[fg=#458588,bg=#d5c4a1]#[fg=#ebdbb2,bold,bg=#458588] SCROLL #[fg=#458588,bg=#d5c4a1]";
                        mode_search = "#[fg=#d65d0e,bg=#d5c4a1]#[fg=#ebdbb2,bold,bg=#d65d0e] SEARCH #[fg=#d65d0e,bg=#d5c4a1]";
                        mode_enter_search = "#[fg=#d65d0e,bg=#d5c4a1]#[fg=#ebdbb2,bold,bg=#d65d0e] ENTER SEARCH #[fg=#d65d0e,bg=#d5c4a1]";
                        mode_rename_tab = "#[fg=#d79921,bg=#d5c4a1]#[fg=#3c3836,bold,bg=#d79921] RENAME TAB #[fg=#d79921,bg=#d5c4a1]";
                        mode_rename_pane = "#[fg=#458588,bg=#d5c4a1]#[fg=#ebdbb2,bold,bg=#458588] RENAME PANE #[fg=#458588,bg=#d5c4a1]";
                        mode_session = "#[fg=#98971a,bg=#d5c4a1]#[fg=#ebdbb2,bold,bg=#98971a] SESSION #[fg=#98971a,bg=#d5c4a1]";
                        mode_prompt = "#[fg=#b16286,bg=#d5c4a1]#[fg=#ebdbb2,bold,bg=#b16286] PROMPT #[fg=#b16286,bg=#d5c4a1]";

                        tab_normal = "#[fg=#a89984,bg=#d5c4a1]#[fg=#ebdbb4,bg=#a89984] {index} {name} #[fg=#a89984,bg=#d5c4a1]";
                        tab_active = "#[fg=#af3a03,bg=#d5c4a1]#[fg=#ebdbb2,bold,bg=#af3a03] {index} {name} #[fg=#af3a03,bg=#d5c4a1]";
                        tab_separator = "";

                        datetime = "{format}";
                        datetime_format = "%d %b %H:%M";
                        datetime_timezone = "local";
                      };
                    };
                  }
                  { "children" = { }; }
                ];
              };
            }
          ];
        };
      };
    };

    settings = {
      theme = "gruvbox-light";
      simplified_ui = true;
      default_shell = "zsh";
      copy_on_select = true;
      show_startup_tips = false;
    };

    extraConfig = ''
      keybinds {
        normal clear-defaults=true {
          bind "Ctrl b" { SwitchToMode "Tmux"; }

          bind "Alt f" { ToggleFloatingPanes; }
          bind "Alt n" { NewPane; }
          bind "Alt i" { MoveTab "Left"; }
          bind "Alt o" { MoveTab "Right"; }
          bind "Alt h" "Alt Left" { MoveFocusOrTab "Left"; }
          bind "Alt l" "Alt Right" { MoveFocusOrTab "Right"; }
          bind "Alt j" "Alt Down" { MoveFocus "Down"; }
          bind "Alt k" "Alt Up" { MoveFocus "Up"; }
          bind "Alt =" "Alt +" { Resize "Increase"; }
          bind "Alt -" { Resize "Decrease"; }
          bind "Alt [" { PreviousSwapLayout; }
          bind "Alt ]" { NextSwapLayout; }
          bind "Alt p" { TogglePaneInGroup; }
          bind "Alt Shift p" { ToggleGroupMarking; }
        }

        tmux clear-defaults=true {
          bind "Ctrl b" { Write 2; SwitchToMode "Normal"; }
          bind "Esc" { SwitchToMode "Normal"; }
          bind "g" { SwitchToMode "Locked"; }
          bind "p" { SwitchToMode "Pane"; }
          bind "t" { SwitchToMode "Tab"; }
          bind "r" { SwitchToMode "Resize"; }
          bind "m" { SwitchToMode "Move"; }
          bind "s" { SwitchToMode "Scroll"; }
          bind "o" { SwitchToMode "Session"; }
          bind "q" { Quit; }

          bind "Ctrl n" "n" { GoToNextTab; SwitchToMode "Normal"; }
          bind "Ctrl p" "p" { GoToPreviousTab; SwitchToMode "Normal"; }
          bind "Ctrl 1" "1" { GoToTab 1; SwitchToMode "Normal"; }
          bind "Ctrl 2" "2" { GoToTab 2; SwitchToMode "Normal"; }
          bind "Ctrl 3" "3" { GoToTab 3; SwitchToMode "Normal"; }
          bind "Ctrl 4" "4" { GoToTab 4; SwitchToMode "Normal"; }
          bind "Ctrl 5" "5" { GoToTab 5; SwitchToMode "Normal"; }
          bind "Ctrl 6" "6" { GoToTab 6; SwitchToMode "Normal"; }
          bind "Ctrl 7" "7" { GoToTab 7; SwitchToMode "Normal"; }
          bind "Ctrl 8" "8" { GoToTab 8; SwitchToMode "Normal"; }
          bind "Ctrl 9" "9" { GoToTab 9; SwitchToMode "Normal"; }
        }
      }
    '';
  };
}
