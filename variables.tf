variable "namespace" {
  description = "Name for ingress nginx namespace"
  type        = string
  default     = "ingress-nginx"
}

variable "helm_chart_version" {
  description = "Version of the ingress-nginx helm chart to install"
  type        = string
  default     = "4.5.2"
}

variable "image_tag" {
  description = "Version tag of the ingress-nginx docker image to use"
  type        = string
  default     = "v1.8.1"
}

variable "chart_repo_url" {
  description = "URL to repository containing the ingress-nginx helm chart"
  type        = string
  default     = "https://kubernetes.github.io/ingress-nginx"
}

variable "helm_values" {
  description = "Values for ingress-nginx Helm chart in raw YAML. If none specified, module will add its own set of default values"
  type        = list(string)
  default     = []
}

variable "load_balancer_type" {
  type        = string
  description = "ingress nginx controller load balancer type"
  default     = "Internal"
}

variable "internal_load_balancer_subnet" {
  type        = string
  description = "ingress nginx controller internal load balancer subnet"
  default     = "my-subnet"
}

variable "ingress_class_is_default" {
  type        = bool
  description = "IngressClass resource default for cluster"
  default     = true
}

variable "extra_set_values" {
  description = "Specific values to override in the ingress-nginx Helm chart (overrides corresponding values in the helm-value.yaml file within the module)"
  type = list(object({
    name  = string
    value = any
    type  = string
    })
  )
  default = []
}