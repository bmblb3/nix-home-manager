{
  description = "NixOS home manager configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixCats-nvim.url = "github:bmblb3/nvim_nixcats";
    nixCats-nvim.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs =
    {
      nixpkgs,
      home-manager,
      nixCats-nvim,
      system,
      ...
    }:
    {
      homeConfigurations = {
        akucwh = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            username = "akucwh";
            inherit nixCats-nvim;
          };
        };
        bmblb3 = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            username = "bmblb3";
            inherit nixCats-nvim;
          };
        };
      };
    };
}
