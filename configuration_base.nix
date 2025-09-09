# Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    home-manager
  ];

  environment.variables.EDITOR = "vim";

  virtualisation.docker.enable = true;

  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;

  programs.ssh.startAgent = true;

  nixpkgs.config.allowUnfree = true;
}
