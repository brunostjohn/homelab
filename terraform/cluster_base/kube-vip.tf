resource "kubernetes_manifest" "kubevip_serviceaccount" {
  manifest = yamldecode(file("${path.module}/../../k8s/kube-vip/serviceaccount.yml"))
}

resource "kubernetes_manifest" "kubevip_clusterrole" {
  manifest = yamldecode(file("${path.module}/../../k8s/kube-vip/clusterrole.yml"))
}

resource "kubernetes_manifest" "kubevip_clusterrolebinding" {
  manifest = yamldecode(file("${path.module}/../../k8s/kube-vip/clusterrolebinding.yml"))
}

resource "kubernetes_manifest" "kubevip_daemonset" {
  manifest = yamldecode(file("${path.module}/../../k8s/kube-vip/daemonset.yml"))
}