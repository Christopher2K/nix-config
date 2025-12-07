{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.resurrect
      tmuxPlugins.pain-control
    ];
    keyMode = "vi";
    mouse = true;
    baseIndex = 1;
    extraConfig = ''
      set -g status on
      set -g status-position top
      set -g status-style bg=#d5c4a1,fg=#594945
      set -g status-interval 1
      set -g status-justify left

      set -g window-status-current-format "#[fg=#ebdbb2,bold bg=#af3a03] #I #W "
      set -g window-status-format "#[fg=#ebdbb4,bg=#a89984] #I #W "
      set -g window-status-separator ""

      set -g status-left-length 40
      set -g status-left-style default
      set -g status-left "#{?client_prefix,[P],}#[fg=#FFFFFF,bold,bg=#7F6E63] #S "

      set -g status-right-length 40
      set -g status-right-style default
      set -g status-right "#[fg=#ffffff,bold bg=#a89984] %H:%M "
      set -g default-command ${pkgs.zsh}/bin/zsh
    '';
  };
}
