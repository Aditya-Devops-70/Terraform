

resource "helm_release" "nats" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  name       = "nats"
  repository = "https://nats-io.github.io/k8s/helm/charts/"
  chart      = "nats"
  namespace  = kubernetes_namespace.bluebird.metadata[0].name
  version    = "v0.19.5"
  set {
    name  = "nats.jetstream.enabled"
    value = "true"
  }
  set {
    name  = "nats.jetstream.fileStorage.enabled"
    value = "true"
  }
  set {
    name  = "nats.limits.maxPayload"
    value = "64mb"
  }
  set {
    name  = "nats.jetstream.fileStorage.storageClassName"
    value = "default"
  }
  set {
    name  = "nats.resources.requests.cpu"
    value = "1"
  }
  set {
    name  = "nats.resources.requests.memory"
    value = "2000Mi"
  }
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
    name  = "natsbox/tolerations[0].effect"
    value = "NoSchedule"
  }
  set {
    name  = "natsbox.tolerations[0].key"
    value = "nodes_pool"
  }
  set {
    name  = "natsbox.tolerations[0].value"
    value = "static"
  }

  timeout = 900 # Timeout in seconds (15 minutes)
}



# output "nat_output" {
# value = kubernetes_storage_class.azure_disk.metadata[0].name

# }

