####################
# resource
####################

# Create ingress-nginx namespace
resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = var.chart_repo_url
  chart      = "ingress-nginx"
  version    = var.helm_chart_version
  namespace  = var.namespace
  values     = length(var.helm_values) > 0 ? var.helm_values : ["${file("${path.module}/helm-values.yaml")}"]
  set {
    name  = "service.type"
    value = "ClusterIP"
  }
  set {
    name  = "controller.service.internal.annotations.networking\\.gke\\.io/load-balancer-type"
    value = var.load_balancer_type
  }
  set {
    name  = "controller.service.internal.annotations.networking\\.gke\\.io/internal-load-balancer-subnet"
    value = var.internal_load_balancer_subnet
  }
  set {
    name  = "controller.ingressClassResource.default"
    value = var.ingress_class_is_default
  }
  dynamic "set" {
    for_each = var.extra_set_values
    content {
      name  = set.value.name
      value = set.value.value
      type  = set.value.type
    }
  }

  depends_on = [
    kubernetes_namespace.ingress_nginx
  ]
}