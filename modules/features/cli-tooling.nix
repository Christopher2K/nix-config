{
  inputs,
  config,
  ...
}:
let
  helpers = config.flake.helpers;
in
{
  flake.modules.homeManager.cli-tooling =
    { pkgs, config, ... }:
    {
      home.packages = with pkgs; [
        bat
        fastfetch
        fd
        fzf
        jq
        nixfmt
        ripgrep
        scrcpy
        unzip
        watchman
      ];

      home.file."${helpers.mkConfigPath config "/glow"}" = {
        source = helpers.mkAssetsPath "/glow";
        recursive = true;
        force = true;
      };

      programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
      };

      programs.yazi = {
        enable = true;
        enableZshIntegration = true;
      };
    };
}
