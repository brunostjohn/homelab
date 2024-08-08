{ node, ... }:

{
  networking.networkmanager.enable = true;
  # this is fine becuase there's a firewall between the internet and the server
  networking.firewall.enable = false;
  networking.hostName = "s${node.num}.${node.type}.zefirscloud.local";
}
