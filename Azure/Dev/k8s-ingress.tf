/*

resource "azurerm_public_ip" "nginx_controller" {
  resource_group_name = azurerm_kubernetes_cluster.aks.node_resource_group      # need in same rg where aks created there own rg
  location            = azurerm_resource_group.rg.location
  name              = "nginx-controller"
  allocation_method = "Static"
}




resource "helm_release" "nginx-ingress" {
  name      = "ingress-nginx"    
  repository = "https://kubernetes.github.io/ingress-nginx"    
  chart     = "ingress-nginx"
  namespace = "nginx"

  values = [
    <<EOF
controller:
  service:
    enabled: true
    type: LoadBalancer
    loadBalancerIP: "${azurerm_public_ip.nginx_controller.ip_address}"
    
EOF

  ]   

   set {
    name  = "controller.service.loadBalancerIP"
    value = "${azurerm_public_ip.nginx_controller.ip_address}"
  }
}

# Cert Manager and Nginx Ingress Controller on AKS

resource "helm_release" "cert_manager" {
  depends_on = [azurerm_kubernetes_cluster.aks]
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  version    = "1.12.0"

  set {
    name  = "installCRDs"
    value = true
  }
}


resource "kubernetes_manifest" "cluster_issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "cluster-issuer-letsencrypt-stage"
    }
    spec = {
      acme = {
        server = "https://acme-staging-v02.api.letsencrypt.org/directory"   #testing certificate
        email  = "contact@bluebird.com"
        privateKeySecretRef = {
          name = "cluster-letsencrypt-stage"
        }
        solvers = [
        {
          http01 = {
            ingress = {
              class = "nginx"
            }
          }
        }
      ]
      }
    }
  }
}



# resource "kubectl_manifest" "backend-timeout" {
# #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
#   provider   = kubectl
#   yaml_body  = <<YAML
# apiVersion: networking.k8s.io/v1
# kind: BackendConfig
# metadata:
#   name: backend-timeout
#   namespace: bluebird
# spec:
#   timeoutSec: 120
#   logging:
#     enable: true
#     sampleRate: 1

# YAML
#   depends_on = [
#     kubernetes_namespace.bluebird
#   ]
# }






resource "kubernetes_ingress_v1" "bluebird-ingress" {
#  count = var.CREATE_K8S_RESOURCES && var.CREATE_INGRESS ? 1 : 0

  metadata {
    name      = "bluebird-ingress"
    namespace = kubernetes_namespace.bluebird.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class"                     = "nginx"  # Use NGINX Ingress Controller class
      "nginx.ingress.kubernetes.io/ssl-redirect"        = "false"  # Disable SSL redirection if using HTTPS
      "nginx.ingress.kubernetes.io/rewrite-target"      = "/"     # Set rewrite target as per your routing requirements
#      "kubernetes.azure.com/tls-cert-keyvault-uri" = azurerm_key_vault_certificate.example.id      
#     for certification we need to add azure key vault here and check during testing how to add certificate here 
    }
  }

  spec {
    ingress_class_name = "nginx"
    tls {
      hosts = [
        "*.azuretest.bluebird.com"
      ]
      secret_name = "cluster-letsencrypt-stage"
    }
    rule {
      host = "auth-${var.APP_DOMAIN}"  # Define your host or domain

      http {
        path {
          path = "/*"  # Define path, or leave it as "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "boxyhq-jackson-service"  # The service name for routing traffic
              port {
                number = 5225  # Port to route traffic to
              }
            }
          }
        }
      }
    }
    rule {
      host = "pusher-${var.APP_DOMAIN}"  # Define your host or domain

      http {
        path {
          path = "/*"  # Define path, or leave it as "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "centrifugo-service"  # The service name for routing traffic
              port {
                number = 8000  # Port to route traffic to
              }
            }
          }
        }
      }
    }

    rule {
      host = "${var.APP_DOMAIN}"  # Define your host or domain

      http {
        path {
          path = "/*"  # Define path, or leave it as "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "blui-svc"  # The service name for routing traffic
              port {
                number = 80  # Port to route traffic to
              }
            }
          }
        }
      }
    }

    rule {
      host = "api-${var.APP_DOMAIN}"  # Define your host or domain

      http {
        path {
          path = "/data-plane-api/*"  # Define path, or leave it as "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "data-plane-api-svc"  # The service name for routing traffic
              port {
                number = 80  # Port to route traffic to
              }
            }
          }
        }

        path {
          path = "/dfx/*"  # Define path, or leave it as "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "dfx-api-svc"  # The service name for routing traffic
              port {
                number = 80  # Port to route traffic to
              }
            }
          }
        }

        path {
          path = "/authz-api/*"  # Define path, or leave it as "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "authz-api-svc"  # The service name for routing traffic
              port {
                number = 80  # Port to route traffic to
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_namespace.bluebird,
  ]
}





resource "kubernetes_service" "blui_svc" {
#  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "blui-svc"
    namespace = kubernetes_namespace.bluebird.metadata[0].name
  }
  spec {
    selector = {
      app = "blui"
    }
    port {
      name = "blui"
      port        = 80
      target_port = "3000"
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_service" "data_plane_api_svc" {
#  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "data-plane-api-svc"
    namespace = kubernetes_namespace.bluebird.metadata[0].name
  }

  spec {
    selector = {
      app = "data-plane-api"
    }
    port {
      name  = "data-plane-api"
      port        = 80
      target_port = 5010
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_service" "dfx_api_svc" {
#  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "dfx-api-svc"
    namespace = kubernetes_namespace.bluebird.metadata[0].name
  }

  spec {
    selector = {
      app = "dfx-api"
    }
    port {
      name = "dfx-api"
      port        = 80
      target_port = 5000
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_service" "auth_api_svc" {
#  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "authz-api-svc"
    namespace = kubernetes_namespace.bluebird.metadata[0].name
  }
 
  spec {
    selector = {
      app = "authz-api"
    }
    port {
      name = "authz-api"
      port        = 80
      target_port = 5030
    }
    type = "ClusterIP"
  }
}

*/