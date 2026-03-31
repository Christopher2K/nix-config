{
  flake.modules.homeManager.kde-apps =
    { pkgs, ... }:
    {
      home.packages = with pkgs.kdePackages; [
        ark
        dolphin
        kcalc
        kwallet
        kwalletmanager
      ];
    };
}
