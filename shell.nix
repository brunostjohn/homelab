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
    yamllint
    yamlfmt
    tflint
    kubetail
    fd
    cmctl
    argocd
    python311Packages.kubernetes
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
