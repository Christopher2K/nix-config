{
  inputs,
  ...
}:
{
  flake.modules.darwin.communication = {
    homebrew.casks = [
      "whatsapp"
      "signal"
      "slack"
    ];
  };

  flake.modules.homeManager.communication =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        vesktop
      ];
    };
}
