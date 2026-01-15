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
}
