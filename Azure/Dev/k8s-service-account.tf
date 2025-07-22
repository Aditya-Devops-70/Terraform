

resource "kubernetes_service_account" "bluebird-admin" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "bluebird-admin"
    namespace = kubernetes_namespace.bluebird.metadata[0].name
  }
  depends_on = [
    kubernetes_namespace.bluebird,
    azurerm_kubernetes_cluster.aks
  ]
}

resource "kubernetes_secret" "bluebird-admin-token" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "bluebird-admin-token"
    namespace = kubernetes_namespace.bluebird.metadata[0].name
    annotations = {
      "kubernetes.io/service-account.name" = "bluebird-admin"
    }
  }
  type = "kubernetes.io/service-account-token"
  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}

resource "kubernetes_role" "bluebird-admin-role" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "bluebird-admin-role"
    namespace = kubernetes_namespace.bluebird.metadata[0].name
  }

  rule {
    api_groups = ["", "batch"]
    resources  = ["pods", "jobs", "pods/log", "pods/exec", "pods/attach", "jobs/log", "jobs/exec", "jobs/attach"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }
  rule {
    api_groups = [""]
    resources  = ["configmaps", "secrets"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }
  rule {
    api_groups = ["argoproj.io"]
    resources  = ["*"]
    verbs      = ["*"]
  }
  rule {
    api_groups = [""]
    resources  = ["*"]
    verbs      = ["*"]
  }

  depends_on = [
    kubernetes_namespace.bluebird,
    azurerm_kubernetes_cluster.aks
  ]
}

resource "kubernetes_role_binding" "bluebird-admin-role-binding" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "bluebird-admin-binding"
    namespace = kubernetes_namespace.bluebird.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.bluebird-admin-role.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.bluebird-admin.metadata[0].name
    namespace = kubernetes_namespace.bluebird.metadata[0].name
  }

  depends_on = [
    kubernetes_role.bluebird-admin-role,
    kubernetes_service_account.bluebird-admin,
    azurerm_kubernetes_cluster.aks
  ]

}

resource "kubernetes_namespace" "cluster-admin" {
  #    count = var.CREATE_K8S_ADMIN_SA && var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name = "cluster-admin"
  }
  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}

resource "kubernetes_service_account" "cluster-admin" {
  #  count = var.CREATE_K8S_ADMIN_SA && var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "cluster-admin"
    namespace = kubernetes_namespace.cluster-admin.metadata[0].name
  }
  depends_on = [
    kubernetes_namespace.bluebird,
    azurerm_kubernetes_cluster.aks
  ]
}

resource "kubernetes_role_binding" "cluster-admin-role-binding" {
  #  count = var.CREATE_K8S_ADMIN_SA && var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "cluster-admin-binding"
    namespace = kubernetes_namespace.cluster-admin.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.cluster-admin.metadata[0].name
    namespace = kubernetes_namespace.bluebird.metadata[0].name
  }

  depends_on = [
    kubernetes_service_account.cluster-admin,
    azurerm_kubernetes_cluster.aks
  ]

}

resource "kubernetes_cluster_role_binding_v1" "cluster-admin-role-binding_v1" {
  #  count = var.CREATE_K8S_ADMIN_SA && var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name = "cluster-admin-binding_v1"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.cluster-admin.metadata[0].name
    namespace = kubernetes_namespace.cluster-admin.metadata[0].name
  }

  depends_on = [
    kubernetes_service_account.cluster-admin,
    azurerm_kubernetes_cluster.aks
  ]

}

resource "kubernetes_secret" "cluster-admin-token" {
  #  count = var.CREATE_K8S_ADMIN_SA && var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "cluster-admin-token"
    namespace = kubernetes_namespace.cluster-admin.metadata[0].name
    annotations = {
      "kubernetes.io/service-account.name" = "cluster-admin"
    }
  }
  type = "kubernetes.io/service-account-token"
  depends_on = [
    azurerm_kubernetes_cluster.aks,
  ]
}

