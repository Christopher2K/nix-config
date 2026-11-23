# simslim turns off the background daemons a simulator doesn't need, so many
# more iOS/tvOS/watchOS/visionOS simulators fit on one Mac. It drives
# `xcrun simctl`, so it needs full Xcode selected, not just Command Line Tools.
{
  flake.modules.darwin.simslim =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.simslim ];
    };
}
