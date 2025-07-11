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

  programs.bash = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      lg = "lazygit";
      cp = "cp -i";
      mv = "mv -i";
    };

    historySize = 100000;
    historyFileSize = 1000000;
    historyControl = [
      "ignoreboth"
      "erasedups"
    ];

    initExtra = ''
      set -o vi
      set -o noclobber
      PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

      bind Space:magic-space
      bind "set completion-ignore-case on"
      bind "set completion-map-case on"
      bind "set show-all-if-ambiguous on"
      bind "set mark-symlinked-directories on"
    '';

    shellOptions = [
      "autocd"
      "cdspell"
      "checkjobs"
      "checkwinsize"
      "cmdhist"
      "dirspell"
      "extglob"
      "globstar"
      "histappend"
    ];

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

  services.ssh-agent.enable = true;
  programs.ssh = {
    enable = true;
    addKeysToAgent = "4h";
  };

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

}
