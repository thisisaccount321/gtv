variable "nginx_release_name" {
  description = "Name of the NGINX Helm release"
  type        = string
  default     = "external-nginx"
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
  type = list(object({
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
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}


variable "filebeat_release_name" {
  description = "The name of the Filebeat Helm release."
  type        = string
}


variable "filebeat_chart_version" {
  description = "The version of the Filebeat Helm chart to deploy."
  type        = string
}

variable "elasticsearch_release_name" {
  description = "The name of the elasticsearch Helm release."
  type        = string
}

variable "elk_namespace" {
  description = "The namespace in which to deploy the ELK stack."
  type        = string
}

variable "elasticsearch_chart_version" {
  description = "The version of the elasticsearch Helm chart to deploy."
  type        = string
}


variable "elasticsearch_set_values" {
  type        = list(object({
    name  = string
    value = string
  }))
  default = []
}


variable "homepage_release_name" {
  description = "The name of the homepage Helm release."
  type        = string
}

variable "homepage_namespace" {
  description = "The namespace in which to deploy the homepage stack."
  type        = string
}

variable "homepage_chart_version" {
  description = "The version of the homepage Helm chart to deploy."
  type        = string
}


variable "homepage_set_values" {
  type        = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "dev_cluster"
}

variable "cluster_version" {
  description = "The Kubernetes version for the EKS cluster."
  type        = string
  default     = "1.27"
}




variable "cluster_endpoint_public_access" {
  description = "Whether to enable public access to the EKS cluster endpoint."
  type        = bool
  default     = false
}

variable "cluster_endpoint_private_access" {
  description = "Whether to enable private access to the EKS cluster endpoint."
  type        = bool
  default     = true
}



variable "databases_ng_node_group_instance_types" {
  type        = string
}

variable "databases_ng_node_group_capacity_min_size" {
  type        = string
}

variable "databases_ng_node_group_capacity_desired_size" {
  type        = string
}

variable "databases_ng_node_group_capacity_max_size" {
  type        = string
}

variable "general_ng_node_group_instance_types" {
  type        = string
}

variable "general_ng_node_group_capacity_min_size" {
  type        = string
}

variable "general_ng_node_group_capacity_desired_size" {
  type        = string
}

variable "general_ng_node_group_capacity_max_size" {
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC."
  type        = string
  default     = "my-vpc"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.1.0.0/16"
}

