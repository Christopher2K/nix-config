{
  pkgs,
  getConfig,
  getDest,
  lib,
  ...
}:
{
  home.file."${getDest ".env.template"}" = {
    source = getConfig ".env.template";
  };

  home.file."${getDest "scripts"}" = {
    source = getConfig "scripts";
    recursive = true;
  };

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
          [[ ! -r '/Users/christopher/.opam/opam-init/init.zsh' ]] || source '/Users/christopher/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
        '';

      in
      lib.mkMerge [
        zshConfigEarlyInit
        zshConfig
      ];

  };

  programs.zsh.oh-my-zsh = {
    enable = true;
    theme = "robbyrussell";
    plugins = [
      "git"
      "sudo"
      "tmux"
    ];
  };

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
}
