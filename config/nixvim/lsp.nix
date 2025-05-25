{ pkgs, ... } :

{
  imports = [ ];

  programs.nixvim = {

    lsp.servers.ruff = {
      enable = true;
      settings.cmd = [ "ruff" "server" ];
    };

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
