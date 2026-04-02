{
  flake.modules.homeManager.darwinSshAgent =
    { pkgs, config, ... }:
    {
      launchd.agents.pass-cli-ssh-agent = {
        enable = true;
        config = {
          ProgramArguments = [
            "${pkgs.proton-pass-cli}/bin/pass-cli"
            "ssh-agent"
            "start"
          ];
          RunAtLoad = true;
          KeepAlive = true;
          StandardOutPath = "${config.home.homeDirectory}/Library/Logs/pass-cli-ssh-agent.log";
          StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/pass-cli-ssh-agent.log";
        };
      };
    };
}
