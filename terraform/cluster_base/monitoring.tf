# module "kube_prometheus_helm" {
#     depends_on = [ argocd_application.longhorn ]
#     source = "../helm_deployment"

#     namespace = "monitoring"
#     create_namespace = true

#     name = "monitoring"
#     chart = "kube-prometheus-stack"
#     repo_url = "https://prometheus-community.github.io/helm-charts"
#     target_revision = "61.7.0"

#     values = templatefile("${path.module}/values/monitoring.yml.tpl", {
#         global_fqdn = var.global_fqdn,
#         namespace = "monitoring",
#     })

#     create_ingress = false
# }