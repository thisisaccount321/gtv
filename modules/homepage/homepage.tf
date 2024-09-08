resource "helm_release" "homepage" {
  name = var.homepage_release_name

  repository       = "https://jameswynn.github.io/helm-charts"
  chart            = "homepage" 
  namespace        = var.homepage_namespace
  create_namespace = true
  version          = var.homepage_chart_version

  values = [file("${path.module}/values/homepage.yaml")]

  dynamic "set" {
    for_each = var.homepage_set_values
    content {
      name  = set.value.name
      value = set.value.value
    }
  }
}


