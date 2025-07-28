{
  config,
  pkgs,
  username,
  nixvim,
  ...
}:

{
  imports = [
    nixvim.homeManagerModules.nixvim
    ./config/nixvim
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";

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
    # neovim (added as nixvim program integration)
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

  programs.fish = {
    enable = true;

    shellAbbrs = {
      lg = "lazygit";
      cp = "cp -i";
      mv = "mv -i";
    };

    functions = {
      fish_greeting = "";
    };
  };

  programs.bash = {
    enable = true;

    initExtra = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  programs.zellij = {
    enable = true;
    settings = {
      theme = "tokyo-night";
      default_mode = "locked";
      pane_frames = false;
      show_startup_tips = false;
      ui.pane_frames.hide_session_name = true;
    };
  };

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

  services.ssh-agent.enable = true;
  programs.ssh = {
    enable = true;
    addKeysToAgent = "12h";
  };

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

}
