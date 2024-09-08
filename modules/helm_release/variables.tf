variable "nginx_release_name" {
  description = "Name of the NGINX Helm release"
  type        = string
  default     = "nginx"
}

variable "external_nginx_release_name" {
  description = "Name of the NGINX Helm release"
  type        = string
  default     = "external-nginx"
}

variable "nginx_chart_version" {
  description = "Version of the NGINX Helm chart"
  type        = string
  default     = "4.8.0"
}

variable "nginx_namespace" {
  description = "Kubernetes namespace for the NGINX release"
  type        = string
  default     = "ingress"
}

variable "cert_manager_release_name" {
  description = "Name of the cert-manager Helm release"
  type        = string
  default     = "cert-manager"
}

variable "cert_manager_chart_version" {
  description = "Version of the cert-manager Helm chart"
  type        = string
  default     = "v1.13.1"
}

variable "cert_manager_namespace" {
  description = "Kubernetes namespace for the cert-manager release"
  type        = string
  default     = "cert-manager"
}

variable "cert_manager_set_values" {
  description = "Additional set values for the cert-manager Helm release"
  type        = list(object({
    name  = string
    value = string
  }))
  default = [
    {
      name  = "installCRDs"
      value = "true"
    }
  ]
}

variable "nginx_set_values" {
  description = "Additional set values for the NGINX Helm release"
  type        = list(object({
    name  = string
    value = string
  }))
  default = []
}