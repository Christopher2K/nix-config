{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (final: prev: {
      proton-pass-cli = prev.proton-pass-cli.overrideAttrs (_: {
        version = "1.6.1";
        src = prev.fetchurl {
          url =
            let
              file =
                {
                  aarch64-darwin = "pass-cli-macos-aarch64";
                  x86_64-darwin = "pass-cli-macos-x86_64";
                  aarch64-linux = "pass-cli-linux-aarch64";
                  x86_64-linux = "pass-cli-linux-x86_64";
                }
                .${prev.stdenv.hostPlatform.system};
            in
            "https://proton.me/download/pass-cli/1.6.1/${file}";
          hash =
            {
              aarch64-darwin = "sha256-xEqD5ET6bi1mr9RscWJ4V2uBRNrjzd08fBet9OCm28I=";
              x86_64-darwin = "sha256-zKBrZYLJpYKF5x2I3pNMtETWtVH9Mqy77or7aBG3sAg=";
              aarch64-linux = "sha256-vmily9b6ukkdRDbnKHRyssn3bvRFhdzxDyYPqIMESs8=";
              x86_64-linux = "sha256-u/S6AVt9N9GUzYSBZJAxqzxNXFTLNttffqLAW3yNKL8=";
            }
            .${prev.stdenv.hostPlatform.system};
        };
      });
    })
  ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  # nix.optimise.automatic = true;
  # nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than +10";
  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];
  environment.systemPackages = with pkgs; [
    bc
  ];
}
