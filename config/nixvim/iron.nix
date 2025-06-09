{ pkgs, ... }:

{

  programs.nixvim = {

    plugins.iron = {
      enable = true;

      settings = {

        keymaps = {
          restart_repl = "<leader>rs";

          visual_send = "<leader><leader>";

          mark_visual = "<leader>rv";
          send_mark = "<leader>rm";

          send_code_block = "<leader><leader>";
          send_code_block_and_move = "<leader>rr";
        };

        ignore_blank_lines = true;

        config = {

          highlight_last = "IronLastSent";

          repl_definition = {

            python = {
              command = [
                "ipython"
                "--no-autoindent"
              ];
              format = {
                __raw = "require('iron.fts.common').bracketed_paste";
              };
              block_dividers = [
                "# %%"
                "#%%"
              ];
            };

            sh = {
              command = [
                "bash"
              ];
            };
          };

          repl_open_cmd = {
            __raw = "require(\"iron.view\").split.vertical.belowright(0.4)";
          };

          scratch_repl = true;
        };
      };
    };
  };
}
