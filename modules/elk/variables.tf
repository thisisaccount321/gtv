variable "filebeat_release_name" {
  description = "The name of the Filebeat Helm release."
  type        = string
}

variable "elk_namespace" {
  description = "The namespace in which to deploy the ELK stack."
  type        = string
}

variable "filebeat_chart_version" {
  description = "The version of the Filebeat Helm chart to deploy."
  type        = string
}


variable "filebeat_set_values" {
  type        = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "elasticsearch_release_name" {
  description = "The name of the elasticsearch Helm release."
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
