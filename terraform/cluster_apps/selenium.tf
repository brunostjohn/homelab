module "selenium_helm" {
  source = "../helm_deployment"

  chart           = "selenium-grid"
  repo_url        = "https://www.selenium.dev/docker-selenium"
  target_revision = "0.34.3"
  values          = file("${path.module}/values/selenium.yml")

  create_namespace = true
  namespace        = "selenium"
  name             = "selenium"

  create_ingress = false
}