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
      unfree = [
        "gh-copilot"
        "vscode"
      ];
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = (
          pkg: builtins.elem (pkg.pname or (builtins.parseDrvName pkg.name).name) unfree
        );
      };

      commonModules = [
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
              (final: prev: {
                osync = osync.packages.${system}.default;
                kittylitters = kittylitters.packages.${system}.default;
              })
            ];
          }
        )
        stylix.homeModules.stylix
      ];

      mkHomeConfig =
        username: machineType:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = commonModules ++ [
            ./machines/${machineType}.nix
          ];
          extraSpecialArgs = {
            inherit username;
          };
        };

    in
    {
      homeConfigurations = {
        akucwh-dev = mkHomeConfig "akucwh" "dev";
        bmblb3-server = mkHomeConfig "bmblb3" "server";
      };
    };
}
