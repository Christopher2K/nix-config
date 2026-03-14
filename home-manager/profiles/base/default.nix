{
  home.stateVersion = "25.11";

  home.sessionVariables = {
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    TMPDIR = "$HOME/.tmp";

    DEV = "$HOME/Developer";

    SSH_AUTH_SOCK = "$HOME/.ssh/proton-pass-agent.sock";

    SHELL_SESSIONS_DISABLE = 1;

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
