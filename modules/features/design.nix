{
  flake.modules.nixos.design =
    { pkgs, ... }:
    let
      pen-dev = import ../software/_pen-dev.nix pkgs;
    in
    {
      environment.systemPackages = [ pen-dev ];
    };

  flake.modules.nixos."3d-design" =
    {
      pkgs,
      ...
    }:
    {
      nixpkgs.overlays = [
        (import ../software/_plasticity-overlay.nix)
      ];

      environment.systemPackages = with pkgs; [
        plasticity
        bambu-studio
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
