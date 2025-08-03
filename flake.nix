{
  description = "NixOS configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs =
    {
      self,
      nixpkgs,
      nixos-wsl,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        wsl-work = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration_wsl.nix
            {
              nix.settings.trusted-users = [
                "root"
                "akucwh"
              ];
              users.users.akucwh.extraGroups = [ "docker" ];
            }
          ];
          specialArgs = {
            inherit nixos-wsl;
            hostname = "wsl-work";
            username = "akucwh";
          };
        };
        hetzner = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration_hetzner.nix
            inputs.disko.nixosModules.disko
            {
              nix.settings.trusted-users = [
                "root"
                "bmblb3"
              ];
              users.users.bmblb3.extraGroups = [
                "docker"
                "wheel"
              ];
              users.users.bmblb3.isNormalUser = true;
            }
          ];
          specialArgs = {
            hostname = "hetzner";
            username = "bmblb3";
          };
        };
      };
    };
}
