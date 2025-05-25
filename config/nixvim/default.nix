{ pkgs, ... } :

{
  imports = [
    ./lazygit.nix
    ./copilot.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;

    colorschemes.catppuccin.enable = true;

    globals.mapleader = " ";
    globals.maplocalleader = " ";
    keymaps = [ ];

    plugins = {
      lualine.enable = true;
      which-key.enable = true;
    };

  };
}
