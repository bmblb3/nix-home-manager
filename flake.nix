{
  description = "NixOS home manager configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixCats-nvim.url = "github:bmblb3/nvim_nixcats";
    nixCats-nvim.inputs.nixpkgs.follows = "nixpkgs";
    osync.url = "github:bmblb3/osync?ref=v0.3.0";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixCats-nvim,
      osync,
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
            ./home.nix
            { home.packages = [ osync.packages.${system}.default ]; }
          ];
          extraSpecialArgs = {
            username = "akucwh";
            inherit nixCats-nvim;
          };
        };
        bmblb3 = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            username = "bmblb3";
            inherit nixCats-nvim;
          };
        };
      };
    };
}
