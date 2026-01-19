{
  pkgs,
  lib,
  ...
}:
{
  programs.mise = {
    enable = true;
    # Disable global zsh integration - direnv handles mise activation per-project
    # This removes the `eval "$(mise activate zsh)"` from shell startup
    # Tools are still available via direnv when you cd into a project
    enableZshIntegration = true;
    globalConfig = {
      settings = {
        all_compile = false;
      };
      tools = {
        bun = "1.2.2";
        elixir = "1.18.4-otp-28";
        erlang = "28.0.2";
        gleam = "1.13.0";
        golang = "1.22.2";
        java = "openjdk-17.0.2";
        kotlin = "2.0.0";
        nodejs = "22.11.0";
        ocaml = "5.4.0";
        opam = "2.2.0";
        python = "3.12.0";
        ruby = "3.2.9";
        rust = "1.75.0";
      };
    };
  };

  # Not working -- Says stuff like curl are missing
  # home.activation.miseInstall = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #   ${pkgs.mise}/bin/mise install
  # '';
}
