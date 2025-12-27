{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  packages = [ pkgs.nodemon ];

  processes.dev.exec = ''
    ags quit || true
    ${pkgs.nodemon}/bin/nodemon --watch . -e ts,tsx,js,jsx,json --exec 'ags run'
  '';
}
