{
  config,
  inputs,
  pkgs,
  configDest,
  ...
}:
{
  home.packages = with pkgs; [
    inputs.qml-niri.packages.${stdenv.hostPlatform.system}.quickshell
    kdePackages.qtdeclarative
    qt6.qt5compat
  ];

  home.sessionVariables = {
    QML_IMPORT_PATH = "${pkgs.qt6.qt5compat}/lib/qt-6/qml";
  };

  home.file."${configDest "quickshell"}".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/files/quickshell";

  systemd.user.services.quickshell = {
    Unit = {
      Description = "Quickshell";
      After = [ "niri.service" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${
        inputs.qml-niri.packages.${pkgs.stdenv.hostPlatform.system}.quickshell
      }/bin/quickshell";
      Restart = "on-failure";
      RestartSec = 3;
      Environment = [
        "QML_IMPORT_PATH=${pkgs.qt6.qt5compat}/lib/qt-6/qml"
      ];
    };
    Install = {
      WantedBy = [ "niri.service" ];
    };
  };
}
