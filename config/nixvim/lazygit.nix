{ pkgs, ... }:

{
  programs.nixvim = {

    extraPackages = with pkgs; [
      lazygit
    ];

    plugins.lazygit.enable = true;

    keymaps = [
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>LazyGit<CR>";
        options = {
          silent = true;
          desc = "[G]it: Launch lazy[g]it";
        };
      }
    ];

  };
}
