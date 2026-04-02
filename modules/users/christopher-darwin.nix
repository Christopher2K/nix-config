# Darwin-specific Home Manager configuration for christopher
{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.christopherDarwin = {
    imports = [
      hm.christopher
      hm.aerospace
      hm.jankyborders
      hm.darwinPackages
      hm.security
    ];
  };
}
