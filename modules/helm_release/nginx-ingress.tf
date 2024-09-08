resource "helm_release" "external-nginx" {
  name = var.external_nginx_release_name

  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = var.nginx_namespace
  create_namespace = true
  version          = var.nginx_chart_version

  values = [file("${path.module}/values/external-nginx.yaml")]

  dynamic "set" {
    for_each = var.nginx_set_values
    content {
      name  = set.value.name
      value = set.value.value
    }
  }
}

resource "helm_release" "nginx" {
  name = var.nginx_release_name

  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = var.nginx_namespace
  create_namespace = true
  version          = var.nginx_chart_version

  values = [file("${path.module}/values/nginx.yaml")]

  dynamic "set" {
    for_each = var.nginx_set_values
    content {
      name  = set.value.name
      value = set.value.value
    }
  }
}