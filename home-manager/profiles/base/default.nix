{
  home.stateVersion = "25.11";

  home.sessionVariables = {
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
  home.shell = {
    enableShellIntegration = true;
  };

  imports = [
    ./stylix.nix
  ];
}
