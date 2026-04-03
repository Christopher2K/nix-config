{
  flake.modules.nixos.gnome-apps =
    { ... }:
    {
      services.gvfs.enable = true;
    };

  flake.modules.homeManager.gnome-apps =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nautilus
        file-roller
        gnome-calculator
        gnome-text-editor
        loupe
        evince
      ];
    };
}
