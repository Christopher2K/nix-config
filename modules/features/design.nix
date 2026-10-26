{
  flake.modules.nixos."3d-design" =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        plasticity
      ];
    };

  flake.modules.darwin.design = {
    homebrew.casks = [
      "figma"
      "cleanshot"
      "cap"
    ];
  };

  flake.modules.darwin."3d-design" = {
    homebrew.casks = [
      "bambu-studio"
      "bambu-connect"
    ];
  };
}
