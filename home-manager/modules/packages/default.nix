{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./packages.common.nix
  ]
  ++ lib.optionals pkgs.stdenv.isDarwin [
    ./packages.darwin.nix
  ]
  ++ lib.optionals pkgs.stdenv.isLinux [
    ./packages.linux.nix
  ];
}
