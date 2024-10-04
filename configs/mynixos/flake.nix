{
  description = "nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-06cb-009a-fingerprint-sensor = {
      url = "github:ahbnr/nixos-06cb-009a-fingerprint-sensor";
    };
  };

  outputs = inputs@{
    self,
    nixpkgs,
    nixpkgs-unstable,
    nixos-hardware,
    nixos-06cb-009a-fingerprint-sensor,
    ...
  }: {
    # Einstein desktop
    nixosConfigurations.einstein = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./modules/nixos/common.nix
        ./hosts/einstein/configuration.nix
      ];
    };
    
    # Thinkpad T480S
    nixosConfigurations.eris = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        nixos-hardware.nixosModules.lenovo-thinkpad-t480s
        ./modules/nixos/common.nix
        ./hosts/eris/configuration.nix
      ];
    };

    # Chromebook
    nixosConfigurations.orcus = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./modules/nixos/common.nix
        ./hosts/orcus/configuration.nix
      ];
    };
  };
}
