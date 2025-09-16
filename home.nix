{
  config,
  pkgs,
  username,
  nixCats-nvim,
  ...
}:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";

  imports = [
    nixCats-nvim.homeModules.default
  ];
  nvim.enable = true;

  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/monokai.yaml";
  stylix.fonts = {
    monospace = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font Mono";
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
    act
    bat
    btop
    cargo
    cargo-generate
    cht-sh
    clang-tools
    cmake
    cookiecutter
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
    imagemagick
    jq
    libevent
    libtool
    lsof
    moreutils
    ncdu
    nix-output-monitor
    nodejs_22
    p7zip
    pandoc
    postgresql
    pre-commit
    python312Full
    quarto
    ripgrep-all
    rmlint
    rsync
    rustc
    (rWrapper.override { packages = [ rPackages.tidyverse ]; })
    sqlite
    sshfs
    tealdeer
    typst
    unzip
    watchexec
    wget
    xsel
    xq-xml
    xz
    yq-go
    zig
    zip
    zstd
  ];

  programs.git = {
    enable = true;
    userName = "Akshay Kumar";
    userEmail = "132216831+bmblb3@users.noreply.github.com";
    extraConfig = {
      credential.helper = "store";
      init.defaultBranch = "main";
      fetch.prune = true;
    };
    delta.enable = true;
  };

  programs.gh = {
    enable = true;
    extensions = with pkgs; [ gh-copilot ];
  };

  programs.gh-dash = {
    enable = true;
    settings = {
      smartFilteringAtLaunch = true;
      defaults = {
        view = "issues";
        preview.width = 64;
      };
      issuesSections = [
        {
          title = "Open";
          filters = "is:open";
        }
        {
          title = "Closed";
          filters = "is:closed";
        }
      ];
      keybindings = {
        universal = [
          {
            key = "g";
            name = "lazygit";
            command = "cd {{.repoPath}} && lazygit";
          }
        ];
        issues = [
          {
            key = "n";
            name = "lazygit";
            command = "gh issue create --editor";
          }
        ];
      };
    };
  };

  programs.starship = {
    enable = true;
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
    addKeysToAgent = "12h";
    matchBlocks = {
      "github.com" = {
        hostname = "ssh.github.com";
        port = 443;
        user = "git";
      };
    };
  };

  programs.kitty = {
    enable = true;
    extraConfig = ''
      include extra.conf
    '';
  };
  home.file.".config/kitty/extra.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/dotconfig/kitty.conf";

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

}
