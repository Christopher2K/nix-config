{
  pkgs,
  homeDest,
  src,
  lib,
  ...
}:
{
  ############
  # Ghostty  #
  ############
  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
    enableZshIntegration = true;
    settings = {
      theme = "Gruvbox Light";
      font-family = "JetBrainsMono Nerd Font Mono";
      font-size = 16;
      macos-titlebar-style = "hidden";
      window-padding-x = 12;
      window-padding-y = 12;
      working-directory = "home";
      window-inherit-working-directory = false;
      window-save-state = "never";
    };
  };

  ##############
  # Global env #
  ##############
  home.file."${homeDest ".env.template"}" = {
    source = src ".env.template";
    force = true;
  };

  ############
  # Scripts  #
  ############
  home.file."${homeDest "scripts"}" = {
    source = src "scripts";
    recursive = true;
    force = true;
  };

  ############
  # ZSH      #
  ############
  programs.zsh = {
    enable = true;
    shellAliases = {
      "switch" =
        if pkgs.stdenv.isDarwin then "sudo darwin-rebuild switch" else "sudo nixos-rebuild switch";
    };
    sessionVariables = {
      LC_ALL = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      TMPDIR = "$HOME/.tmp";

      # ZSH_TMUX_AUTOSTART = "true";
      ZSH_TMUX_AUTOQUIT = "false";

      DEV = "$HOME/Developer";
      COOKIN = "$DEV/cookin";

      # Android
      ANDROID_ROOT = "$HOME/Library/Android";
      ANDROID_SDK_ROOT = "$ANDROID_ROOT/sdk";
      ANDROID_PLATFORM_TOOLS = "$ANDROID_SDK_ROOT/platform-tools";
      ANDROID_HOME = "$ANDROID_SDK_ROOT";
      PATH = "$PATH:$ANDROID_PLATFORM_TOOLS";

      # Erlang
      ERL_AFLAGS = "-kernel shell_history enabled";
    };

    initContent =
      let
        zshConfigEarlyInit = lib.mkOrder 500 ''
          delete_localonly_branches () {
            git fetch -p

            for branch in $(git branch --format "%(refname:short)"); do
              if ! git show-ref --quiet refs/remotes/origin/$branch; then
                echo "Delete local $branch"
                git branch -D $branch
              fi
            done
          }

          alias delete_localonly_branch="delete_localonly_branches"

          # Load cached environment variables from 1Password
          CACHE_FILE="$HOME/.cache/env/.env.cache"

          if [ -f "$CACHE_FILE" ]; then
            source "$CACHE_FILE"
          else
            echo "⚠️  No cached environment variables found. Running: ~/scripts/secure-env-refresh"
            ~/scripts/secure-env-refresh.sh
            source "$CACHE_FILE"
          fi
        '';
        zshConfig = lib.mkOrder 1500 ''
          # OPAM init
          [[ ! -r "/$HOME/.opam/opam-init/init.zsh" ]] || source "$HOME/.opam/opam-init/init.zsh" > /dev/null 2> /dev/null
        '';

      in
      lib.mkMerge [
        zshConfigEarlyInit
        zshConfig
      ];

  };

  ############
  # OhMyZsh  #
  ############
  programs.zsh.oh-my-zsh = {
    enable = true;
    theme = "robbyrussell";
    plugins = [
      "git"
      "sudo"
      "tmux"
    ];
  };

  ############
  # Starship #
  ############
  programs.starship = {
    enable = true;
    settings = {
      command_timeout = 10000;
      format = "$character$directory";
      right_format = "$all";

      ruby.detect_variables = [ ];
      cmd_duration = {
        min_time = 0;
        show_milliseconds = false;
      };
    };
  };

  ############
  # Tmux     #
  ############
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
