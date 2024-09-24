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
      globalModulesMNode = globalModulesNixOS ++ [ ./nix/modules/clusterNode ];
      eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f (import nixpkgs { inherit system; config.allowUnfree = true; }));
    in
    {
      nixosConfigurations = {
        s1 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs.node = {
            ipAddress = "10.0.0.2";
            macAddress = "bc:24:11:de:e6:94";
            hostname = "s1";
          };
          modules = [
            ./nix/hosts/s1
            ./nix/modules/k3sInitiator
          ] ++ globalModulesMNode;
        };

        s2 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs.node = {
            ipAddress = "10.0.3.3";
            macAddress = "bc:24:11:fa:16:37";
            hostname = "s2";
          };
          modules = [
            ./nix/hosts/s2
            ./nix/modules/k3sAgent
            ./nix/modules/nvidiaGpu
          ] ++ globalModulesMNode;
        };

        s3 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs.node = {
            ipAddress = "10.0.0.6";
            macAddress = "bc:24:11:c0:02:b1";
            hostname = "s3";
          };
          modules = [
            ./nix/hosts/s3
            ./nix/modules/k3sMaster
          ] ++ globalModulesMNode;
        };

        s4 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs.node = {
            ipAddress = "10.0.0.7";
            macAddress = "bc:24:11:27:1f:e1";
            hostname = "s4";
          };
          modules = [
            ./nix/hosts/s4
            ./nix/modules/k3sAgent
          ] ++ globalModulesMNode;
        };

        s5 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs.node = {
            ipAddress = "10.0.0.8";
            macAddress = "bc:24:11:b8:f7:09";
            hostname = "s5";
          };
          modules = [
            ./nix/hosts/s5
            ./nix/modules/k3sMaster
          ] ++ globalModulesMNode;
        };

        s6 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs.node = {
            ipAddress = "10.0.0.9";
            macAddress = "bc:24:11:ba:82:94";
            hostname = "s6";
          };
          modules = [
            ./nix/hosts/s6
            ./nix/modules/k3sAgent
          ] ++ globalModulesMNode;
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
