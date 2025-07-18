{ pkgs, ... }:

{

  programs.nixvim = {

    plugins.lspconfig.enable = true;

    plugins.conform-nvim = {
      enable = true;

      settings = {
        format_on_save = {
          lsp_format = "fallback";
          timeout_ms = 500;
        };
        default_format_opts = {
          lsp_format = "fallback";
        };
        notify_on_error = true;
        notify_no_formatters = true;
      };
    };

    keymaps = [
      {
        key = "<leader>lf";
        action = "<cmd>lua require('conform').format({lsp_format='fallback', timeout_ms=2000})<CR>";
        options = {
          silent = true;
          desc = "[L]sp: [F]ormat";
        };
      }
    ];
  };
}
