{ inputs, ... }:
{
  flake.modules.nixos.launcher = {
    nixpkgs.overlays = [
      inputs.vicinae.overlays.default
    ];
  };

  flake.modules.homeManager.launcher =
    { pkgs, ... }:
    {
      imports = [
        inputs.vicinae.homeManagerModules.default
      ];

      services.vicinae = {
        enable = true;
        systemd = {
          enable = true;
          autoStart = true;
          environment = {
            USE_LAYER_SHELL = 1;
          };
        };
        settings = {
          font = {
            size = 11;
          };
        };
      };
    };
}
