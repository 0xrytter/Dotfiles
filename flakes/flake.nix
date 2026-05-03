{
  description = "NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable }:
  let
    system = "x86_64-linux";
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in
  {
    nixosConfigurations = {
      DIY-Desktop = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = { inherit pkgs-unstable; };
        modules = [ ./hosts/DIY-Desktop/configuration.nix ];
      };

      T480 = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = { inherit pkgs-unstable; };
        modules = [ ./hosts/T480/configuration.nix ];
      };

      patrick-desktop = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = { inherit pkgs-unstable; };
        modules = [ ./hosts/patrick-desktop/configuration.nix ];
      };
    };
  };
}
