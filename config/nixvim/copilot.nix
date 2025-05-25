{ pkgs, ... } :

{
  programs.nixvim = {

    plugins.copilot-lua.enable = true;
    plugins.copilot-chat.enable = true;

    keymaps = [
      {
        key = "<leader>aic";
        action = "<cmd>CopilotChatCommit<CR>";
        options = {
          silent = true;
          desc = "[AI]: Generate [c]ommit message";
        };
      }
    ];

  };
}
