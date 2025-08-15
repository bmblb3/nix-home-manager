{
  description = "NixOS home manager configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixCats-nvim.url = "git+https://github.com/bmblb3/nvim_nixcats?ref=main";
    nixCats-nvim.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixCats-nvim,
      ...
    }@inputs:
    {
      homeConfigurations = {
        akucwh = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            username = "akucwh";
            inherit nixCats-nvim;
          };
        };
        bmblb3 = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            username = "bmblb3";
            inherit nixCats-nvim;
          };
        };
      };
    };
}
