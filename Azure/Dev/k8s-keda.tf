

resource "helm_release" "keda" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  name       = "keda"
  repository = "https://kedacore.github.io/charts"
  chart      = "keda"
  namespace  = kubernetes_namespace.bluebird.metadata[0].name
  version    = "v2.10.2"
  timeout    = 1800

  set {
    name  = "tolerations[0].effect"
    value = "NoSchedule"
  }
  set {
    name  = "tolerations[0].key"
    value = "nodes_pool"
  }
  set {
    name  = "tolerations[0].value"
    value = "static"
  }
  set {
    name  = "nodeSelector.nodes_pool"
    value = "static"
  }

}


