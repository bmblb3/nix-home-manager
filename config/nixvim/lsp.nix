{ pkgs, ... } :

{

  programs.nixvim = {

    plugins.lspconfig.enable = true;

    keymaps = [
      {
        key = "<leader>lf";
        action.__raw = "vim.lsp.buf.format";
        options = {
          silent = true;
          desc = "[L]sp: [F]ormat";
        };
      }
    ];

  };
}
