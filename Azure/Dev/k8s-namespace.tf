

resource "kubernetes_namespace" "bluebird" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  provider = kubernetes
  metadata {
    name = var.NAMESPACE
  }
  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]

}


resource "kubernetes_namespace" "cert_manager" {
  provider = kubernetes
  metadata {
    name = "cert-manager"
  }
}







# output "k8_namespace" {
#  value = kubernetes_namespace.bluebird.metadata[0].name 
# }


