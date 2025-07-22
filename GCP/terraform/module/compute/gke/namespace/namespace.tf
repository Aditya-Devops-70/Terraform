resource "kubernetes_namespace" "gke_namespace" {
 provider = kubernetes
 metadata {
   name = var.name
 }
}