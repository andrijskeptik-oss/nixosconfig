{
  description = "Vinga NixOS";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    hyprland.url = "github:hyprwm/Hyprland";
#    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
#    nixos-cosmic.inputs.nixpkgs.follows = "nixpkgs";
 };

#  outputs = { self, nixpkgs,nixos-cosmic,  ... }:
  outputs = { self, nixpkgs, hyprland, ... }:
  {
    nixosConfigurations.vinga = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit hyprland; };
      modules = [
        ./configuration.nix
#        nixos-cosmic.nixosModules.default
      ];
    };
  };
}
