{ pkgs, ... }:

{
  programs.nixvim = {
    lsp.servers.nil_ls.enable = true;
  };
}
