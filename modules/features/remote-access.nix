{ config, ... }:
let
  helpers = config.flake.helpers;
  username = config.flake.username;
in
{
  flake.modules.nixos.remote-access =
    { pkgs, ... }:
    let
      moondeck-buddy = pkgs.stdenv.mkDerivation {
        pname = "moondeck-buddy";
        version = "1.11.0";

        src = pkgs.fetchFromGitHub {
          owner = "FrogTheFrog";
          repo = "moondeck-buddy";
          rev = "078c235d9517c07668df3fdb811fdd1cdbbd9f41";
          hash = "sha256-/zS1Rl8slZndQaEK8TN/rBg9STsMjsUIzS9ci72cBCk=";
          fetchSubmodules = true;
        };

        nativeBuildInputs = [
          pkgs.cmake
          pkgs.pkg-config
          pkgs.qt6.wrapQtAppsHook
        ];

        buildInputs = [
          pkgs.qt6.qtbase
          pkgs.qt6.qtwebsockets
          pkgs.qt6.qthttpserver
          pkgs.procps
        ];

        meta = {
          description = "Server-side buddy app for the MoonDeck Steam Deck plugin";
          homepage = "https://github.com/FrogTheFrog/moondeck-buddy";
          license = pkgs.lib.licenses.lgpl3Only;
          platforms = pkgs.lib.platforms.linux;
          mainProgram = "MoonDeckBuddy";
        };
      };
    in
    {
      services.sunshine = {
        enable = true;
        autoStart = true;
        capSysAdmin = true; # required for KMS capture on Wayland (niri)
        openFirewall = true;
      };

      hardware.uinput.enable = true;

      users.users.${username}.extraGroups = [ "uinput" ];

      environment.systemPackages = [ moondeck-buddy ];

      services.tailscale.enable = true;

      # VNC is only reachable over the tailnet, never on the LAN or internet.
      networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 5900 ];
    };

  flake.modules.darwin.remote-access = {
    services.tailscale.enable = true;
  };
}
