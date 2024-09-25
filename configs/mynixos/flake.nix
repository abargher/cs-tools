{
  description = "nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { nixpkgs, ... } @ inputs:
  {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/default/configuration.nix
      ];
    };
    
    nixosConfigurations.orcus = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/orcus/configuration.nix
      ];
    };

  };
}
