{ config, pkgs, username, ... }:

{

  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.packages = with pkgs; [
    bat
    btop
    cargo
    clang-tools
    cmake
    curl
    direnv
    docker-compose
    dos2unix
    # eza
    fd
    file
    fzf
    gawk
    gcc
    # git
    git-filter-repo
    glow
    gnumake
    gnupg
    gnused
    gnutar
    hugo
    imagemagick
    jq
    lazygit
    libevent
    libtool
    lsof
    ncdu
    neovim
    ninja
    nix-output-monitor
    nodejs_22
    p7zip
    pandoc
    python310
    quarto
    R
    ripgrep
    ripgrep-all
    rmlint
    rsync
    rustc
    sqlite
    sqlitebrowser
    # starship
    sysstat
    tealdeer
    typst
    unzip
    uv
    vifm
    vim
    watchexec
    wget
    xclip
    xz
    yq-go
    zellij
    zig
    zip
    # zoxide
    zstd
  ];

  programs.git = {
    enable = true;
    userName = "Akshay Kumar";
    userEmail = "132216831+bmblb3@users.noreply.github.com";
  };

  programs.starship = {
    enable = true; 
    settings = {
      username.show_always = true;
      hostname.ssh_only = true;
    };
  };

  programs.eza = {
    enable = true; 
    git = true;
  };

  programs.zoxide = {
    enable = true; 
    options = ["--cmd cd"];
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      vi = "nvim";
    };
  };

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

}
