{
  pkgs,
  ...
}:
{
  programs.mise = {
    enable = true;
    enableZshIntegration = true;
    globalConfig = {
      tools = {
        bun = "1.2.2";
        elixir = "1.18.4-otp-28";
        erlang = "28.0.2";
        gleam = "1.3.2";
        golang = "1.22.2";
        java = "openjdk-17.0.2";
        kotlin = "2.0.0";
        nodejs = "22.11.0";
        ocaml = "5.2.0";
        opam = "2.2.0";
        python = "3.10.7";
        ruby = "3.2.9";
        rust = "1.75.0";
      };
    };
  };
}
