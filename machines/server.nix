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

  home.packages = with pkgs; [
    btop
    curl
    docker-compose
    dos2unix
    file
    gawk
    gnupg
    gnused
    gnutar
    jq
    lsof
    moreutils
    ncdu
    python312
    ripgrep-all
    rsync
    wget
    xq-xml
    xsel
    yq-go
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

  programs.bash = {
    enable = true;

    shellAliases = {
      lg = "lazygit";
      cp = "cp -i";
      mv = "mv -i";
    };

    bashrcExtra = ''
      set -o vi
    '';
  };

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

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  programs.rclone = {
    enable = true;
  };

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

}
