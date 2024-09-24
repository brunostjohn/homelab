{ node, ... }:

{
  networking.domain = "m-nodes.zefirscloud.local";
  networking.defaultGateway = "10.0.0.1";
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
  networking.interfaces.lan0.ipv4.addresses = [
    {
      address = node.ipAddress;
      prefixLength = 16;
    }
  ];
  networking.hostName = node.hostname;
  boot.kernel.sysctl."kernel.hostname" = "${node.hostname}.m-nodes.zefirscloud.local";
}
