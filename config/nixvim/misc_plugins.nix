{ pkgs, ... }:

{

  programs.nixvim = {

    plugins = {
      ts-comments.enable = true;

      mini = {
        enable = true;
        modules = {
          pairs = { };
          ai = { };
        };
      };

      flash.enable = true;
    };
  };
}
