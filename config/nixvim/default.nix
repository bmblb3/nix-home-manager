{ pkgs, ... }:

{
  imports = [
    ./copilot.nix
    ./lang/nix.nix
    ./lang/python.nix
    ./lazygit.nix
    ./lsp.nix
    ./misc_plugins.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;

    colorschemes.catppuccin.enable = true;

    globals.mapleader = " ";
    globals.maplocalleader = ",";
    keymaps = [ ];

    opts = {
      autowrite = true;
      completeopt = "menu,menuone,noselect";
      confirm = true;
      cursorline = true;
      expandtab = true;
      fillchars = {
        foldopen = "";
        foldclose = "";
        fold = " ";
        foldsep = " ";
        diff = "╱";
        eob = " ";
      };
      foldlevel = 99;
      formatoptions = "jcrqlnt";
      grepprg = "rg --vimgrep";
      ignorecase = true;
      jumpoptions = "view";
      laststatus = 3;
      linebreak = true;
      list = true;
      mouse = "a";
      number = true;
      pumblend = 20;
      relativenumber = true;
      ruler = false;
      scrolloff = 4;
      sessionoptions = [
        "buffers"
        "curdir"
        "tabpages"
        "winsize"
        "help"
        "globals"
        "skiprtp"
        "folds"
      ];
      shiftround = true;
      shiftwidth = 2;
      shortmess = "ltToOcCFWI";
      showmode = false;
      sidescrolloff = 4;
      signcolumn = "yes";
      smartcase = true;
      softtabstop = 2;
      spelllang = "en";
      splitbelow = true;
      splitkeep = "screen";
      splitright = true;
      tabstop = 2;
      undofile = true;
      undolevels = 10000;
      updatetime = 200;
      virtualedit = "block";
      wildmode = "longest:full,full";
      winminwidth = 5;
      wrap = false;
    };

    plugins = {
      lualine.enable = true;
      which-key.enable = true;
    };

  };
}
