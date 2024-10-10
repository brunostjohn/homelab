{ pkgs, ... }:

{
  imports = [
    ./homebrew.nix
    ./dock.nix
    ./systemSettings.nix
  ];

  environment.systemPackages =
    with pkgs; [
      nixpkgs-fmt
      nixd
      gitAndTools.gh
      corepack_22
      nodejs_22
      kubectl
      kubectl-cnpg
      terraform
    ];

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  nix.settings.experimental-features = "nix-command flakes";

  programs.zsh.enable = true;

  system.stateVersion = 4;

  nixpkgs.hostPlatform = "aarch64-darwin";
}
