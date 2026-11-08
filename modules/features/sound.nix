{
  flake.modules.darwin.sound = {
    home.brews = [
      "loopback"
    ];
  };

  flake.modules.nixos.sound =
    { ... }:
    {
      security.rtkit.enable = true;

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };
    };

  flake.modules.homeManager.sound =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        pavucontrol
      ];
    };
}
