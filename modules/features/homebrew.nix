{
  config,
  inputs,
  lib,
  ...
}:
let
  username = config.flake.username;
in
{
  # Create a factory function for homebrew modules with host-specific casks
  flake.helpers.mkDarwinHomebrew =
    casks:
    { config, ... }:
    {
      nix-homebrew = {
        enable = true;
        enableRosetta = false;
        mutableTaps = false;
        user = username;
        taps = {
          "homebrew/homebrew-core" = inputs.homebrew-core;
          "homebrew/homebrew-cask" = inputs.homebrew-cask;
        };
      };

      homebrew = {
        enable = true;
        onActivation.cleanup = "uninstall";
        brews = [
          "libyaml"
          "xcodes"
        ];
        taps = builtins.attrNames config.nix-homebrew.taps;
        casks = casks;
      };
    };

  # Also provide the base module without casks for reference
  flake.modules.darwin.homebrew =
    { config, ... }:
    {
      nix-homebrew = {
        enable = true;
        enableRosetta = false;
        mutableTaps = false;
        user = username;
        taps = {
          "homebrew/homebrew-core" = inputs.homebrew-core;
          "homebrew/homebrew-cask" = inputs.homebrew-cask;
        };
      };

      homebrew = {
        enable = true;
        onActivation.cleanup = "uninstall";
        brews = [
          "libyaml"
          "xcodes"
        ];
        taps = builtins.attrNames config.nix-homebrew.taps;
      };
    };
}
