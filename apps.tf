module "helm_release" {
  source                      = "./modules/helm_release"
  nginx_release_name          = var.nginx_release_name
  external_nginx_release_name = var.external_nginx_release_name
  nginx_chart_version         = var.nginx_chart_version
  nginx_namespace             = var.nginx_namespace

  cert_manager_release_name  = var.cert_manager_release_name
  cert_manager_chart_version = var.cert_manager_chart_version
  cert_manager_namespace     = var.cert_manager_namespace
  cert_manager_set_values = [
    {
      name  = "installCRDs"
      value = "true"
    }
  ]
}

module "elk" {
  source                 = "./modules/elk"
  filebeat_release_name  = var.filebeat_release_name
  elk_namespace          = var.elk_namespace
  filebeat_chart_version = var.filebeat_chart_version

  elasticsearch_release_name  = var.elasticsearch_release_name
  elasticsearch_chart_version = var.elasticsearch_chart_version

}


module "homepage" {
  source                 = "./modules/homepage"
  homepage_release_name  = var.homepage_release_name
  homepage_namespace     = var.homepage_namespace
  homepage_chart_version = var.homepage_chart_version

}





data "aws_region" "current" {}
