{
  inputs,
  config,
  ...
}:
{
  flake.nixosModules.nixstationConfiguration =
    {
      config,
      lib,
      pkgs,
      modulesPath,
      ...
    }:

    {
    };
}
