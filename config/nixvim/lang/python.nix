{ pkgs, ... }:

{
  programs.nixvim = {

    lsp.servers.ruff.enable = true;

    lsp.servers.ty = {
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
}
