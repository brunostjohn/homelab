{
  description = "System Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:LnL7/nix-darwin";
    systems.url = "github:nix-systems/default";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, systems, ... }@inputs:
    let
      globalModules = [ ];
      globalModulesNixOS = globalModules ++ [ ];
      globalModulesDarwin = globalModules ++ [ ];
      globalModulesMNode = globalModules ++ [ ];
      eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f (import nixpkgs { inherit system; config.allowUnfree = true; }));
    in
    {
      nixosConfigurations = {
        s1 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nix/s1/configuration.nix
          ];
        };

        s2 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nix/s2/configuration.nix
          ];
        };

        s3 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nix/s3/configuration.nix
          ];
        };

        s4 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nix/s4/configuration.nix
          ];
        };

        s5 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nix/s5/configuration.nix
          ];
        };

        s6 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nix/s6/configuration.nix
          ];
        };
      };
      darwinConfigurations = { };

      # Dev Shell for this repo
      devShells = eachSystem
        (pkgs: {
          default = import ./shell.nix { inherit pkgs; };
        });
    };
}
