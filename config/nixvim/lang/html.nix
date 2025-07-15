{ pkgs, ... }:

{

  programs.nixvim = {

    extraPackages = with pkgs; [
      djlint
    ];

    plugins.conform-nvim.settings.formatters_by_ft.html = [ "djlint" ];
  };
}
