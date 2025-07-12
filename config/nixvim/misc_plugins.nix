{ pkgs, ... }:

{

  programs.nixvim = {

    plugins = {
      ts-comments.enable = true;

      vim-dadbod.enable = true;
      vim-dadbod-completion.enable = true;
      vim-dadbod-ui.enable = true;

      mini = {
        enable = true;
        modules = {
          pairs = { };
          ai = { };
        };
      };

      flash = {
        enable = true;
        settings = {
          labels = "asdfghjklqwertyuiopzxcvbnm";
        };
      };
    };

    keymaps = [
      {
        mode = [
          "n"
          "x"
          "o"
        ];
        key = "s";
        action = "<cmd>lua require('flash').jump()<CR>";
        options = {
          silent = true;
          desc = "Flash: Jump";
        };
      }
      {
        mode = [
          "n"
          "x"
          "o"
        ];
        key = "S";
        action = "<cmd>lua require('flash').treesitter()<CR>";
        options = {
          silent = true;
          desc = "Flash: Treesitter";
        };
      }

      {
        mode = [ "o" ];
        key = "r";
        action = "<cmd>lua require('flash').remote()<CR>";
        options = {
          silent = true;
          desc = "Flash: Remote";
        };
      }
      {
        mode = [
          "x"
          "o"
        ];
        key = "R";
        action = "<cmd>lua require('flash').treesitter_search()<CR>";
        options = {
          silent = true;
          desc = "Flash: Treesitter search";
        };
      }
      {
        mode = [ "c" ];
        key = "<c-s>";
        action = "<cmd>lua require('flash').toggle()<CR>";
        options = {
          silent = true;
          desc = "Flash: Treesitter toggle";
        };
      }
    ];
  };
}
