{ pkgs, ... }:

{

  programs.nixvim = {

    plugins = {

      blink-copilot.enable = true;

      blink-cmp = {

        enable = true;

        settings = {

          cmdline.enabled = false;

          sources = {

            default = [
              "lsp"
              "path"
              "snippets"
              "buffer"
              "copilot"
            ];

            providers = {
              copilot = {
                async = true;
                module = "blink-copilot";
                name = "copilot";
                score_offset = 100;
              };
            };
          };
        };
      };
    };
  };
}
