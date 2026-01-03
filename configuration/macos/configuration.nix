{
  username,
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../common.nix
    ./macos-defaults.nix
    ./homebrew.nix
  ];

  # Disable darwin-nix self version management
  nix.enable = false;

  nixpkgs.hostPlatform = "aarch64-darwin";

  environment.etc.nix-darwin.source = "/Users/${username}/nix-config";

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
