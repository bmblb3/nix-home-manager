{ pkgs, ... } :

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;

    extraPackages = with pkgs; [
      lazygit
    ];

    colorschemes.catppuccin.enable = true;

    plugins = {
      lualine.enable = true;

      copilot-lua.enable = true;
      copilot-chat.enable = true;

      lazygit.enable = true;

      which-key.enable = true;

    };

    globals.mapleader = " ";
    globals.maplocalleader = " ";
    keymaps = [
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>LazyGit<CR>";
        options = {
          silent = true;
          desc = "Launch lazygit";
        };
      }
    ];

  };
}
