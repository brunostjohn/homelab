{ config, node, ... }:

{
  services.openiscsi.name =
    "s${node.num}.${node.type}.zefirscloud.local.iscsi:${config.networking.hostName}";
}
