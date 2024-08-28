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
      globalModulesNixOS = globalModules ++ [
        (import ./nix/nodes/base-linux/default.nix { inherit nixpkgs; })
      ];
      globalModulesDarwin = globalModules ++ [ ];
      globalModulesMNode = globalModules ++ [ ];
      eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f (import nixpkgs { inherit system; config.allowUnfree = true; }));
    in
    {
      nixosConfigurations = { };
      darwinConfigurations = { };

      # Dev Shell for this repo
      devShells = eachSystem
        (pkgs: {
          default = import ./shell.nix { inherit pkgs; };
        });
    };
}
