{
  config,
  pkgs,
  lib,
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

  home.packages = with pkgs; [
    bat
    btop
    cargo
    cht-sh
    clang-tools
    cmake
    curl
    devenv
    # direnv (added as program integration)
    docker-compose
    dos2unix
    # eza (added as program integration)
    # fd (added as program integration)
    file
    # fzf (added as program integration)
    gawk
    gcc
    # git (added as program integration)
    git-filter-repo
    glow
    gnumake
    gnupg
    gnused
    gnutar
    hugo
    imagemagick
    jq
    # lazygit (added as program integration)
    libevent
    libtool
    moreutils
    lsof
    ncdu
    # neovim (added as nixCats module)
    ninja
    nix-output-monitor
    nodejs_22
    p7zip
    pandoc
    postgresql
    python310
    quarto
    R
    # ripgrep (added as program integration)
    ripgrep-all
    rmlint
    rsync
    rustc
    sqlcheck
    sqlite
    sqlitebrowser
    sshfs
    # starship (added as program integration)
    sysstat
    tealdeer
    typst
    typstyle
    unzip
    vifm
    watchexec
    wget
    xclip
    xq-xml
    xz
    yq-go
    # zellij (added as program integration)
    zig
    zip
    # zoxide (added as program integration)
    zstd
  ];

  programs.git = {
    enable = true;
    userName = "Akshay Kumar";
    userEmail = "132216831+bmblb3@users.noreply.github.com";
    extraConfig = {
      credential.helper = "store";
      init.defaultBranch = "main";
    };
    delta.enable = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      username.show_always = true;
      hostname.ssh_only = false;
      scan_timeout = 20;
      command_timeout = 50;
    };
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
    };
  };

  programs.zellij = {
    enable = true;
  };
  xdg.configFile."zellij/config.kdl".text = ''
    theme "catppuccin-macchiato"
    default_mode "locked"
    pane_frames false
    show_startup_tips false
    ui {
      pane_frames {
        hide_session_name true
      }
    }
    keybinds {
        locked {
            bind "Shift Left" { MoveFocusOrTab "Left"; }
            bind "Shift Right" { MoveFocusOrTab "Right"; }
            bind "Shift Up" { MoveFocus "Up"; }
            bind "Shift Down" { MoveFocus "Down"; }
        }
    }
  '';

  programs.visidata = {
    enable = true;
    visidatarc = ''
      options.clipboard_copy_cmd='xclip -selection clipboard -filter'
      options.clipboard_paste_cmd='xclip -selection clipboard -o'
    '';
  };

  programs.pgcli.enable = true;

  home.file = {
    ".local/bin" = {
      source = ./scripts;
      recursive = true;
    };
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  programs.ssh = {
    enable = true;
    addKeysToAgent = "12h";
  };

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

}
