{ pkgs, ... }:

{

  programs.nixvim = {

    extraPackages = with pkgs; [
      nixfmt-rfc-style
    ];

    lsp.servers.nil_ls.enable = true;

    plugins.conform-nvim.settings.formatters_by_ft.nix = [ "nixfmt" ];
  };
}
