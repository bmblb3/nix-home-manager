{ pkgs, ... } :

{
  programs.nixvim = {
  
    plugins.copilot-lua.enable = true;
    plugins.copilot-chat.enable = true;

    keymaps = [ ];

  };
}
