{ ... }:
{
  imports = [
    ../../home-manager/profiles/base
    ../../home-manager/modules/code
    ../../home-manager/modules/terminal
    ../../home-manager/modules/tools
    ../../home-manager/modules/packages
    ../../home-manager/profiles/linux

    # Host-specific
    ./kanshi.nix
  ];
}
