{ config, ... }:
let
  helpers = config.flake.helpers;
  testResult = helpers.mkHybrid "test" {
    common =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.hello ];
        home.sessionVariables.TEST_COMMON = "common";
      };
    linux =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.cowsay ];
        home.sessionVariables.TEST_LINUX = "linux";
      };
  };
in
{
  flake.modules.homeManager.testMkHybrid = testResult;
}
