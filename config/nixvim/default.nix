{ pkgs, ... } :

{
  imports = [
    ./lazygit.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;

    colorschemes.catppuccin.enable = true;

    plugins = {
      lualine.enable = true;

      copilot-lua.enable = true;
      copilot-chat.enable = true;

      which-key.enable = true;

    };

    globals.mapleader = " ";
    globals.maplocalleader = " ";
    keymaps = [ ];

  };
}
