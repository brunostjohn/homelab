{ nodeType, nodeMacAddress, nodeStaticIp, nodeHostname, ... }:

{
  networking.interfaces.lan0.ipv4.addresses = [
    {
      address = nodeStaticIp;
      prefixLength = 16;
    }
  ];
  networking.defaultGateway = "10.0.0.1";
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  networking.hostName = nodeHostname;
  networking.domain = "${nodeType}-nodes.zefirscloud.local";
  systemd.network.links."10-lan" = {
    matchConfig.PermanentMACAddress = nodeMacAddress;
    linkConfig.Name = "lan0";
  };
  networking.firewall.enable = true;
}
