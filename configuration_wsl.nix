# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

# Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  nixos-wsl,
  hostname,
  username,
  ...
}:

{

  imports = [
    nixos-wsl.nixosModules.default
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  # -- Custom config starts here -- #

  wsl = {
    enable = true;
    defaultUser = username;
    wslConf.network.hostname = hostname;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
  ];

  environment.variables.EDITOR = "vim";

  virtualisation.docker = {
    enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  # Enable GPU support
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;
  environment.sessionVariables = {
    CUDA_PATH = "${pkgs.cudatoolkit}";
    EXTRA_LDFLAGS = "-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib";
    EXTRA_CCFLAGS = "-I/usr/include";
    LD_LIBRARY_PATH = [
      "/usr/lib/wsl/lib"
      "${pkgs.linuxPackages.nvidia_x11}/lib"
      "${pkgs.ncurses5}/lib"
    ];
    MESA_D3D12_DEFAULT_ADAPTER_NAME = "Nvidia";
  };
  hardware.nvidia-container-toolkit = {
    enable = true;
    mount-nvidia-executables = false;
  };
  systemd.services = {
    nvidia-cdi-generator = {
      description = "Generate nvidia cdi";
      wantedBy = [ "docker.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /etc/cdi";
        ExecStart = "${pkgs.writeShellScript "nvidia-cdi-gen" ''
          export LD_LIBRARY_PATH="/usr/lib/wsl/lib:/usr/lib/wsl/drivers:$LD_LIBRARY_PATH"
          ${pkgs.nvidia-docker}/bin/nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml --nvidia-ctk-path=${pkgs.nvidia-container-toolkit}/bin/nvidia-ctk
        ''}";
      };
    };
  };
  virtualisation.docker = {
    daemon.settings.features.cdi = true;
    daemon.settings.cdi-spec-dirs = [ "/etc/cdi" ];
  };
}
