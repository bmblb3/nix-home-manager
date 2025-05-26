{ pkgs, ... } :

{

  programs.nixvim = {

    keymaps = [
      {
        key = "<leader>lf";
        action = "<cmd>lua vim.lsp.buf.format()<CR>";
        options = {
          silent = true;
          desc = "[L]sp: [F]ormat";
        };
      }
    ];

  };
}
