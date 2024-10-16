{ node, ... }:

{
  services.k3s = {
    enable = true;
    role = "agent";
    tokenFile = /deploy/clustertoken;
    serverAddr = "https://10.0.2.22:6443";
    extraFlags = "--node-name ${node.hostname}.m-nodes.zefirscloud.local --embedded-registry";
  };
}
