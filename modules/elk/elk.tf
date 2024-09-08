resource "helm_release" "filebeat" {
  name = var.filebeat_release_name

  repository       = "https://helm.elastic.co"
  chart            = "filebeat"    
  namespace        = var.elk_namespace
  create_namespace = true
  version          = var.filebeat_chart_version

  values = [file("${path.module}/values/filebeat.yaml")]

  dynamic "set" {
    for_each = var.filebeat_set_values
    content {
      name  = set.value.name
      value = set.value.value
    }
  }
  depends_on = [
    helm_release.elasticsearch
  ]
}


resource "helm_release" "elasticsearch" {
  name = var.elasticsearch_release_name

  repository       = "https://helm.elastic.co"
  chart            = "elasticsearch"    
  namespace        = var.elk_namespace
  create_namespace = true
  version          = var.elasticsearch_chart_version

  values = [file("${path.module}/values/elasticsearch.yaml")]

  dynamic "set" {
    for_each = var.elasticsearch_set_values
    content {
      name  = set.value.name
      value = set.value.value
    }
  }
}