{
  flake.modules.homeManager.darwinPackages =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        vlc-bin-universal
      ];
    };
}
