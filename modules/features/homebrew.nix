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
        taps = builtins.attrNames config.nix-homebrew.taps;
      };
    };
}
