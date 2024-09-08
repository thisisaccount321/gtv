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