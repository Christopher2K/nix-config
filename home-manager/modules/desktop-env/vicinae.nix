{
  inputs,
  ...
}:
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
      window = {
        csd = true;
        opacity = 0.9;
        rouding = 10;
      }
    };
  };
}
