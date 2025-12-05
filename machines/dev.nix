{
  config,
  pkgs,
  lib,
  username,
  ...
}:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";

  stylix.enable = true;
  stylix.base16Scheme = {
    system = "base16";
    name = "Monokai";
    palette = {
      base00 = "#1a1a1a";
      base01 = "#1e1e1e";
      base02 = "#282828";
      base03 = "#808080";
      base04 = "#d6d6d6";
      base05 = "#e4e4e4";
      base06 = "#f2f2f2";
      base07 = "#ffffff";
      base08 = "#F51281";
      base09 = "#fd971f";
      base0A = "#f4bf75";
      base0B = "#57BF4A";
      base0C = "#66d9ef";
      base0D = "#268bd2";
      base0E = "#8c54fe";
      base0F = "#e6db74";
    };
  };
  stylix.fonts = {
    monospace = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMonoNL Nerd Font Mono";
    };
    emoji = {
      package = pkgs.noto-fonts-monochrome-emoji;
      name = "Noto Emoji";
    };
    sizes = {
      terminal = 18;
    };
  };

  home.packages = with pkgs; [
    bat
    btop
    cargo
    cargo-generate
    cht-sh
    clang-tools
    cmake
    cookiecutter
    copier
    curl
    docker-compose
    dos2unix
    file
    gawk
    gcc
    git-cliff
    git-filter-repo
    gnumake
    gnupg
    gnuplot
    gnused
    gnutar
    hyperfine
    imagemagick
    inkscape
    jq
    kittylitters
    lazysql
    libevent
    libtool
    lsof
    moreutils
    ncdu
    nix-output-monitor
    nodejs_22
    osync
    p7zip
    pandoc
    php
    postgresql
    pre-commit
    python312
    quarto
    ripgrep-all
    rmlint
    rsync
    rustc
    (rWrapper.override { packages = [ rPackages.tidyverse ]; })
    sqldiff
    sqlite
    sqlpage
    sshfs
    tealdeer
    typst
    potrace
    unzip
    watchexec
    wget
    xq-xml
    xsel
    xz
    yq-go
    zig
    zip
    zstd
  ];

  programs.git = {
    enable = true;
    settings = {
      user.email = "132216831+bmblb3@users.noreply.github.com";
      user.name = "Akshay Kumar";
      credential.helper = "store";
      init.defaultBranch = "main";
      fetch.prune = true;
    };
    lfs.enable = true;
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.gh = {
    enable = true;
    extensions = with pkgs; [ gh-copilot ];
  };

  programs.gh-dash = {
    enable = true;
    settings = {
      smartFilteringAtLaunch = true;
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = lib.mkMerge [
      (builtins.fromTOML (
        builtins.readFile "${pkgs.starship}/share/starship/presets/nerd-font-symbols.toml"
      ))
    ];

  };

  programs.eza = {
    enable = true;
    git = true;
    colors = "always";
    icons = "auto";
    extraOptions = [ "--group-directories-first" ];
  };

  programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
  };

  programs.fzf = {
    enable = true;
  };

  programs.ripgrep = {
    enable = true;
  };

  programs.fd = {
    enable = true;
  };

  programs.carapace = {
    enable = true;
  };

  programs.lazygit = {
    enable = true;
    settings = {
      gui.nerdFontsVersion = "3";
      git.pagers = [
        {
          pager = "delta --dark --paging=never";
          colorArg = "always";
        }
      ];
    };
  };

  programs.lazydocker = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.atuin = {
    enable = true;
    settings = {
      enter_accept = false;
      keymap_mode = "auto";
      style = "auto";
      exit_mode = "return-query";
    };
    flags = [
      "--disable-up-arrow"
    ];
  };

  programs.yazi.enable = true;

  programs.fish = {
    enable = true;

    interactiveShellInit = "set -g fish_key_bindings fish_vi_key_bindings";

    shellAbbrs = {
      lg = "lazygit";
      cp = "cp -i";
      mv = "mv -i";
    };

    functions = {
      fish_greeting = "";
      fish_title = ''
        set -l dir (pwd)
        if test "$dir" = "$HOME"
            echo "~"
        else
            basename "$dir"
        end
      '';
    };
  };

  programs.pgcli.enable = true;

  home.file.".local/bin".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/scripts";

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "12h";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
      "github.com" = {
        hostname = "ssh.github.com";
        port = 443;
        user = "git";
      };
    };
  };

  programs.codex.enable = true;

  programs.neovim = {
    enable = true;

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraPackages = with pkgs; [
      basedpyright
      bash-language-server
      clippy
      djlint
      docker-language-server
      fd
      google-java-format
      jinja-lsp
      lua-language-server
      nil
      nixfmt-rfc-style
      phpactor
      prettierd
      pretty-php
      ripgrep
      ruff
      rust-analyzer
      rustfmt
      shellcheck
      shellharden
      shfmt
      stylua
      superhtml
      tailwindcss-language-server
      typescript-language-server
      typstyle
      universal-ctags
      yaml-language-server
    ];

    plugins = with pkgs.vimPlugins; [
      CopilotChat-nvim
      blink-cmp
      blink-copilot
      blink-ripgrep-nvim
      conform-nvim
      copilot-lua
      dial-nvim
      flash-nvim
      lualine-nvim
      mini-diff
      mini-hipatterns
      nvim-lint
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      persistence-nvim
      snacks-nvim
      todo-comments-nvim
      vim-dirdiff
      which-key-nvim
    ];

    extraLuaConfig = ''
      require("config")
    '';
  };
  home.file.".config/nvim/lua".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/nvim/lua";
  home.file.".config/nvim/after".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/nvim/after";
  home.file.".config/nvim/queries".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/nvim/queries";
  home.file.".config/nvim/ftplugin".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/nvim/ftplugin";

  programs.kitty = {
    enable = true;
    extraConfig = ''
      include extra.conf
    '';
  };
  home.file.".config/kitty/extra.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/kitty/extra.conf";
  home.file.".config/kitty/init.kitty-session".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/kitty/init.kitty-session";
  home.file.".config/kitty/tab_bar.py".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/kitty/tab_bar.py";

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

}
