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
    ports = [ 15168 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # backup data every 5 minutes
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

  # reboot everynight
  systemd.timers."nightly-reboot" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 02:30:00";
      Persistent = true;
      Unit = "nightly-reboot.service";
    };
  };
  systemd.services."nightly-reboot" = {
    description = "Nightly reboot at 02:30";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      ExecStart = "${pkgs.systemd}/bin/systemctl reboot";
    };
  };

  # run janitor
  systemd.timers."nightly-janitor" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 03:00:00";
      Persistent = true;
      Unit = "nightly-janitor.service";
    };
  };
  systemd.services."nightly-janitor" = {
    description = "Run janitor nightly at 03:00";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      ExecStart = "${pkgs.bash}/bin/bash -lc '/home/${username}/.local/bin/janitor'";
    };
  };

  services.journald.extraConfig = ''
    SystemKeepFree=5G
    SystemMaxUse=200M
    SystemMaxFileSize=50M
    RuntimeMaxUse=100M
  '';

  networking.hostName = hostname;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 15168 ];
    allowedUDPPorts = [ ];
    logRefusedConnections = true;
  };

}
