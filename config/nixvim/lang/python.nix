{ pkgs, ... }:

{

  programs.nixvim = {

    extraPackages = with pkgs; [
      ruff
      ty
    ];

    lsp.servers = {

      ruff.enable = true;

      ty = {
        enable = true;
        settings = {
          cmd = [
            "ty"
            "server"
          ];
          filetypes = [ "python" ];
          root_markers = [
            "ty.toml"
            "pyproject.toml"
            ".git"
          ];
        };
      };
    };

    plugins.conform-nvim.settings.formatters_by_ft.python = [ "ruff_format" ];
  };
}
