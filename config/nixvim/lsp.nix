{ pkgs, ... }:

{

  programs.nixvim = {

    extraPackages = with pkgs; [
      nixfmt-rfc-style
      ruff
      ty
    ];

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

        formatters_by_ft = {
          python = [ "ruff_format" ];
          nix = [ "nixfmt" ];
        };
      };
    };

    keymaps = [
      {
        key = "<leader>lf";
        action = "<cmd>require('conform').format(lsp_format = 'fallback')<CR>";
        options = {
          silent = true;
          desc = "[L]sp: [F]ormat";
        };
      }
    ];

  };
}
