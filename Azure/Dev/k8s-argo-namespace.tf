

# Namespace for Argo
resource "kubernetes_namespace" "argo" {
  provider = kubernetes
  metadata {
    name = "argo"
  }
}

resource "kubernetes_namespace" "argo-events" {
  provider = kubernetes
  metadata {
    name = "argo-events"
  }
}


resource "kubernetes_namespace" "nginx" {
  provider = kubernetes
  metadata {
    name = "nginx"
  }
}
