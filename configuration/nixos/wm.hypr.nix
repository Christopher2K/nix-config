{
  config,
  pkgs,
  hyprland,
  ...
}:

{
  # For hyprland to be working on my Razer Blade 16 2025, I had to disable the iGPU
  # The PC is now only running using the dGPU (NVIDIA RTX 5070Ti)
  programs.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    withUWSM = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd 'uwsm start hyprland-uwsm.desktop'";
        user = "greeter";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    hyprpaper
    kitty
  ];
}
