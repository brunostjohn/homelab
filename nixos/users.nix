{ pkgs, ... }:

{
  users.users.brunostjohn = {
    isNormalUser = true;
    description = "Bruno St John";
    extraGroups = [ "networkmanager" "wheel" "docker" "sudo" ];
    packages = with pkgs; [ fastfetch ];
  };

  users.users.klaudiastrugacz = {
    isNormalUser = true;
    description = "Klaudia Strugacz";
    extraGroups = [ "networkmanager" "wheel" "docker" "sudo" ];
    packages = with pkgs; [ fastfetch ];
  };
}
