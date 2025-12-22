{
  username,
  config,
  pkgs,
  homebrew-cask,
  homebrew-core,
  neovim-nightly-overlay,
  ...
}:
{
  imports = [
    ./macos-defaults.nix
    ./homebrew.nix
  ];

  nix = {
    # Disable darwin-nix self version management
    enable = false;
    settings.experimental-features = "nix-command flakes";
  };

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };

  environment.etc.nix-darwin.source = "/Users/${username}/dotfiles";

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  users.users.${username}.home = "/Users/${username}";

  power.sleep = {
    computer = "never";
    display = 30;
    harddisk = "never";
  };

  security.pam.services.sudo_local = {
    enable = true;
    reattach = true;
    touchIdAuth = true;
  };

  system = {
    primaryUser = username;
    # Set Git commit hash for darwin-version.
    configurationRevision = config.rev or config.dirtyRev or null;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 6;

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };
}
