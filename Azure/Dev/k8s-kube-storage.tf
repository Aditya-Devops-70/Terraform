

resource "kubernetes_manifest" "bluebird_nfs_pv" {
  manifest = {
    apiVersion = "v1"
    kind       = "PersistentVolume"
    metadata = {
      name = "bluebird-nfs-new1"
      labels = {
        type = "nfs"
      }
    }
    spec = {
      capacity = {
        storage = "1Gi"
      }
      accessModes = [
        "ReadWriteMany"
      ]
      nfs = {
        server = azurerm_private_endpoint.storage_pe.private_service_connection[0].private_ip_address # Use private IP
        path   = "/bluebirdfilestore70/copa"
      }
    }
  }
}



resource "kubernetes_manifest" "bluebird_nfs_pvc" {
  manifest = {
    apiVersion = "v1"
    kind       = "PersistentVolumeClaim"
    metadata = {
      name      = "bluebird-nfs-new1"
      namespace = "default"
    }
    spec = {
      accessModes = [
        "ReadWriteMany"
      ]
      storageClassName = ""
      resources = {
        requests = {
          storage = "1Gi"
        }
      }
      selector = {
        matchLabels = {
          type = "nfs"
        }
      }
    }
  }
}



resource "kubernetes_pod" "nfs_pod_new" {
  metadata {
    name = "test-pod-bluebird"
  }

  spec {
    node_selector = {
      "kubernetes.io/os" = "linux"
    }

    container {
      name  = "nfs-pod-new1"
      image = "mcr.microsoft.com/oss/nginx/nginx:1.15.5-alpine"

      resources {
        requests = {
          cpu    = "100m"
          memory = "128Mi"
        }

        limits = {
          cpu    = "250m"
          memory = "256Mi"
        }
      }

      volume_mount {
        name       = "bluebird-nfs-new1"
        mount_path = "/mnt/azure"
        read_only  = false
      }
    }

    volume {
      name = "bluebird-nfs-new1"

      nfs {
        server = azurerm_private_endpoint.storage_pe.private_service_connection[0].private_ip_address # Use the private IP address of the NFS server
        path   = "/bluebirdfilestore70/copa"
      }
    }
  }
}

