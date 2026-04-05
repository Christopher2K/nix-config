# Build-time workarounds for mise-compiled runtimes on NixOS.
# NixOS splits headers and libraries across multiple store paths,
# which breaks configure scripts that expect a single prefix.
# This module exposes the right paths so kerl (Erlang) and
# ruby-build (Ruby) can find their dependencies.
{ config, ... }:
{
  flake.modules.nixos.mise-fixes =
    { pkgs, ... }:
    {
      # Erlang/kerl build dependencies
      environment.systemPackages = with pkgs; [
        autoconf
        automake
        perl
        ncurses
        openssl
        libxslt
        bubblewrap # Needed by opam
        mercurial
        darcs
      ];
    };

  flake.modules.homeManager.mise-fixes =
    { pkgs, ... }:
    let
      # Erlang/kerl needs headers and libs under a single prefix.
      # NixOS splits openssl into separate outputs (dev, lib), so we
      # merge them with symlinkJoin.
      opensslCombined = pkgs.symlinkJoin {
        name = "openssl-combined";
        paths = [
          pkgs.openssl.dev
          (pkgs.lib.getLib pkgs.openssl)
        ];
      };
      kerlConfigureOptions = builtins.concatStringsSep " " [
        "--with-ssl=${opensslCombined}"
        "--without-javac"
      ];
    in
    {
      home.sessionVariables = {
        # Erlang/kerl
        KERL_CONFIGURE_OPTIONS = kerlConfigureOptions;
        KERL_BUILD_DOCS = "yes";

        # Ruby/ruby-build and other compiled runtimes need headers
        # and libraries that NixOS keeps in per-package store paths.
        C_INCLUDE_PATH = builtins.concatStringsSep ":" [
          "${pkgs.ncurses.dev}/include"
          "${pkgs.zlib.dev}/include"
          "${pkgs.libyaml.dev}/include"
          "${pkgs.libffi.dev}/include"
          "${pkgs.readline.dev}/include"
        ];
        LIBRARY_PATH = builtins.concatStringsSep ":" [
          "${pkgs.lib.getLib pkgs.ncurses}/lib"
          "${pkgs.lib.getLib pkgs.zlib}/lib"
          "${pkgs.lib.getLib pkgs.libyaml}/lib"
          "${pkgs.lib.getLib pkgs.libffi}/lib"
          "${pkgs.lib.getLib pkgs.readline}/lib"
        ];
      };
    };
}
