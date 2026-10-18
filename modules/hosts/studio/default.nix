{ inputs, config, ... }:
let
  darwin = config.flake.modules.darwin;
  hm = config.flake.modules.homeManager;
  username = config.flake.username;
in
{
  flake.darwinConfigurations.studio = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      inputs.nix-homebrew.darwinModules.nix-homebrew

      # system-level configuration
      darwin.coding
      darwin.homebrew
      darwin.launcher
      darwin.storage
      darwin.terminal
      darwin.security
      darwin.theme

      darwin.studioConfiguration

      inputs.home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";
        home-manager.users.${username} = {
          imports = [
            hm.christopher
            hm.ai
            hm.cli-tooling
            hm.coding
            hm.terminal
            hm.theme
            hm.security

            # Studio is rebuilt over SSH with no Aqua session, so the gui-domain
            # launchd agent fails to bootstrap (error 125: domain does not
            # support specified action). The zsh hook in hm.security starts the
            # daemon on first shell instead.
            (
              { lib, ... }:
              {
                launchd.agents.pass-cli-ssh-agent.enable = lib.mkForce false;
              }
            )
          ];
        };
      }
    ];
  };
}
