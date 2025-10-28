 {
   pkgs,
   neovim-nightly-overlay,
   ...
 } : {
   programs.neovim = {
     enable = true;
     package = neovim-nightly-overlay.packages.${pkgs.system}.default;
     defaultEditor = true;
     viAlias = true;
     vimAlias = true;
   };
 }