{
  description = "nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { nixpkgs, nixos-hardware, ... } @ inputs:
  {
    # Einstein desktop
    nixosConfigurations.einstein = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/einstein/configuration.nix
      ];
    };
    
    # Thinkpad T480S
    nixosConfigurations.eris = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        nixos-hardware.nixosModules.lenovo-thinkpad-t480s
        ./hosts/eris/configuration.nix
      ];
    };

    # Chromebook
    nixosConfigurations.orcus = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/orcus/configuration.nix
      ];
    };
  };
}
