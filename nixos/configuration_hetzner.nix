{
  config,
  lib,
  pkgs,
  hostname,
  username,
  ...
}:

{

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  imports = [
    ./hardware-configuration_hetzner.nix
    ./disko-config_hetzner.nix
    ./configuration_base.nix
  ];

  boot.loader.grub.enable = true;

  services.openssh = {
    enable = true;
    settings.X11Forwarding = true;
  };

  systemd.timers."shbackup" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*:0/5";
      Persistent = true;
      Unit = "shbackup.service";
    };
  };
  systemd.services."shbackup" = {
    path = with pkgs; [
      bash
      restic
      rclone
    ];
    serviceConfig = {
      Type = "oneshot";
      User = username;
      WorkingDirectory = "/home/${username}/self_hosted";
      ExecStart = "/home/${username}/self_hosted/backup";
    };
  };

  networking.hostName = hostname;
}
