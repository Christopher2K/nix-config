{
  flake.modules.homeManager.darwinPackages =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        orbstack
        tableplus
        vlc-bin-universal
      ];
    };
}
