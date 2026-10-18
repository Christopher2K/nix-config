{
  config,
  ...
}:
let
  username = config.flake.username;
in
{
  flake.modules.darwin.studioConfiguration = {
    # Disable nix-darwin self version management
    nix.enable = false;
    nixpkgs.hostPlatform = "aarch64-darwin";
    nixpkgs.config.allowUnfree = true;

    environment.etc.nix-darwin.source = "/Users/${username}/NixConfig";

    users.users.${username}.home = "/Users/${username}";

    power.sleep = {
      computer = "never";
      display = 30;
      harddisk = "never";
    };

    system = {
      primaryUser = username;
      # Set Git commit hash for darwin-version.
      configurationRevision = (config.rev or config.dirtyRev or null);

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      stateVersion = 6;

      keyboard = {
        enableKeyMapping = true;
        remapCapsLockToEscape = true;
      };
    };
  };
}
