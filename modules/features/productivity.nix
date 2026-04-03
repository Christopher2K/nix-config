{
  flake.modules.darwin.productivity = {
    homebrew.cask = [
      "bezel"
      "notion"
    ];
  };

  flake.modules.darwin.productivity-cookunity = {
    homebrew.cask = [
      "notion"
      "linear-linear"
      "tuple"
    ];
  };
}
