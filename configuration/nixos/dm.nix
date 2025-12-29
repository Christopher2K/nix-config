{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  # For hyprland to be working on my Razer Blade 16 2025, I had to disable the iGPU
  # The PC is now only running using the dGPU (NVIDIA RTX 5070Ti)
  # programs.hyprland = {
  #   enable = true;
  #   package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  #   portalPackage =
  #     inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  #   withUWSM = true;
  # };
  #
  # programs.uwsm = {
  #   enable = true;
  #   waylandCompositors.hyprland.binPath = lib.mkForce "/run/current-system/sw/bin/start-hyprland";
  # };
  #
  # services.hyprdynamicmonitors = {
  #   enable = true;
  #   mode = "system";
  # };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd 'niri-session'";
        # command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd 'uwsm start hyprland-uwsm.desktop'";
        # command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd '${lib.getExe config.programs.uwsm.package} start -e -D Hyprland hyprland-uwsm.desktop'";
        user = "greeter";
      };
    };
  };
}
