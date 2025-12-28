{ pkgs, ... }:
{

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
  ];

  programs.zsh.enable = true;
  programs.bash.enable = true;
  programs.firefox.enable = true;
  programs._1password.enable = true;
  programs._1password-gui.enable = true;
  programs.steam.enable = true;

  # Gnome related shit
  programs.dconf.enable = true;
  programs.nautilus-open-any-terminal.enable = true;
  programs.nautilus-open-any-terminal.terminal = "ghostty";
  services.gnome.sushi.enable = true;
  services.gnome.tinysparql.enable = true;

  environment.systemPackages = with pkgs; [
    gcc
    gnumake
    gnupg
    pkg-config
    cmake
    lshw
    pciutils
    unzip
    vim
  ];
}
