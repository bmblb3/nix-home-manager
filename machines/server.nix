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
    python312Full
    ripgrep-all
    rsync
    wget
    xq-xml
    xsel
    yq-go
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
      git.paging = {
        colorArg = "always";
        pager = "delta --dark --paging=never";
      };
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

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

}
