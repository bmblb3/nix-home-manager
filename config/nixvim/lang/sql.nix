{ pkgs, ... }:

{

  programs.nixvim = {

    extraPackages = with pkgs; [ sqruff ];

    plugins.conform-nvim.settings.formatters_by_ft.sql = [ "sqruff" ];
  };
}
