{ pkgs, ... } :

{

  programs.nixvim = {

    lsp.servers.ruff = {
      enable = true;
      settings.cmd = [ "ruff" "server" ];
    };

  };
}
