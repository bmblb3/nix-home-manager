{
  description = "NixOS home manager configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    osync.url = "github:bmblb3/osync?ref=v0.3.0";
    kittylitters.url = "github:bmblb3/kittylitters?ref=latest";
    stylix.url = "github:nix-community/stylix/release-25.05";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      osync,
      kittylitters,
      stylix,
      ...
    }:
    let
      system = "x86_64-linux";
      unfree = [ "gh-copilot" ];
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = (
          pkg: builtins.elem (pkg.pname or (builtins.parseDrvName pkg.name).name) unfree
        );
      };
    in
    {
      homeConfigurations = {
        akucwh = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            (
              { pkgs, ... }:
              {
                nixpkgs.overlays = [
                  (final: prev: {
                    unstable = import nixpkgs-unstable {
                      system = final.system;
                      config.allowUnfree = true;
                    };
                  })
                ];
              }
            )
            ./home.nix
            {
              home.packages = [
                osync.packages.${system}.default
                kittylitters.packages.${system}.default
              ];
            }
            stylix.homeModules.stylix
          ];
          extraSpecialArgs = {
            username = "akucwh";
          };
        };
        bmblb3 = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home.nix
            stylix.homeModules.stylix
          ];
          extraSpecialArgs = {
            username = "bmblb3";
          };
        };
      };
    };
}
