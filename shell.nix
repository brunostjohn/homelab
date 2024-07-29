{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:

pkgs.mkShell {
  shellHook = ''
    alias tf=terraform
    alias k=kubectl
    alias t=task
  '';

  packages = with pkgs; [
    ansible
    terraform
    nil
    nixfmt-classic
    go-task
    kubectl
    caddy
    yamllint
    yamlfmt
    tflint
    envsubst
    fd
    (wrapHelm kubernetes-helm {
      plugins = with pkgs.kubernetes-helmPlugins; [
        helm-secrets
        helm-diff
        helm-s3
        helm-git
      ];
    })
  ];
}
