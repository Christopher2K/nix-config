{
  pkgs,
  ...
}:
{
  programs.zsh = {
    enable = true;
    shellAliases = {
      "switch" = "sudo darwin-rebuild switch";
    };
    sessionVariables = {
      LC_ALL = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";

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

    initContent = ''
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
    '';
  };

  programs.zsh.oh-my-zsh = {
    enable = true;
    theme = "robbyrussell";
    plugins = [
      "git"
      "sudo"
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