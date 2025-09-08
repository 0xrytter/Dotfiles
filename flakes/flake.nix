{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11"; # Bump this to update packages, among other things.
  };

  outputs = { self, nixpkgs }: 
  let
    system = "x86_64-linux";
  in
  {
    nixosConfigurations = {
      DIY-Desktop = nixpkgs.lib.nixosSystem {
        system = system;
        modules = [
          ./hosts/DIY-Desktop/configuration.nix
          ./hosts/DIY-Desktop/hardware-configuration.nix
        ];
      };
      T480 = nixpkgs.lib.nixosSystem {
        system = system;
        modules = [
          ./hosts/T480/configuration.nix
          ./hosts/T480/hardware-configuration.nix
        ];
      };
    };
  };
}

