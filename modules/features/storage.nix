{
  inputs,
  ...
}:
{
  flake.modules.darwin.storage = {
    homebrew.casks = [
      "cyberduck"
      "proton-drive"
      "transmission"
    ];
  };

  # macOS gets the official Proton Drive app via homebrew; on NixOS we use the
  # unofficial GTK4 client (https://github.com/narrrl/proton-drive-linux).
  # Its module installs the package, starts the user service in graphical
  # sessions, and enables the fusermount3 wrapper + GNOME Keyring.
  flake.modules.nixos.storage = {
    imports = [ inputs.proton-drive-linux.nixosModules.default ];

    services.proton-drive-linux.enable = true;

    # Binary cache so the client downloads instead of compiling (trusted-users
    # only; new substituters take effect on the *next* rebuild).
    nix.settings = {
      substituters = [ "https://proton-drive-linux.cachix.org" ];
      trusted-public-keys = [
        "proton-drive-linux.cachix.org-1:w1+3pXVXyTlqkFGn3dWpUhlaJtyGhSm3X0mFwfa++AA="
      ];
    };
  };
}
