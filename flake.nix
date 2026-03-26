{
  description = "Vinga NixOS";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
 
  
 };

   outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs:
    let
      system = "x86_64-linux"; 
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true; 
      };
    in {
      nixosConfigurations.vinga = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit unstable; }; 
        modules = [ ./configuration.nix ];
      };
    };
 
}
