{

  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nixCats-nvim.url = "git+file:./nvim";
    nixCats-nvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-wsl,
      home-manager,
      nixCats-nvim,
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

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.akucwh = ./home.nix;
              home-manager.extraSpecialArgs = {
                username = "akucwh";
                inherit nixCats-nvim;
              };
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

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.bmblb3 = ./home.nix;
              home-manager.extraSpecialArgs = {
                username = "bmblb3";
                inherit nixCats-nvim;
              };
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
