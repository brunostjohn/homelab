{ pkgs, ... }:

{
  users.users.brunostjohn = {
    isNormalUser = true;
    description = "Bruno St John";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEnV+roEnvzvCtDJPEOx7DoP0gPQBLWHUKfsG9twTiGv brunost.john@icloud.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII3q4MlXwUAQ8CJunI6yPHuAWPmdqPocrgedkOZPGy5E brunostjohn@MacBookPro.localdomain"
    ];
  };

  services.getty.autologinUser = "brunostjohn";
}
