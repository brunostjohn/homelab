{ ... }:

{
  networking.hostName = "meowbox";
  networking.networkmanager.enable = true;
  networking.hostId = "941c1b5f";
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall.enable = false;
}
