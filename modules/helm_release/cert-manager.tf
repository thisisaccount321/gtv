resource "helm_release" "cert_manager" {
  name = var.cert_manager_release_name

  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = var.cert_manager_namespace
  create_namespace = true
  version          = var.cert_manager_chart_version

  dynamic "set" {
    for_each = var.cert_manager_set_values
    content {
      name  = set.value.name
      value = set.value.value
    }
  }
}



# MANUALLY INSTALL
# resource "kubernetes_manifest" "cluster_issuer" {
#   manifest = yamldecode(file("${path.module}/issuer-production/issuer-production.yaml"))

#   depends_on = [
#     helm_release.cert_manager
#   ]
# }



