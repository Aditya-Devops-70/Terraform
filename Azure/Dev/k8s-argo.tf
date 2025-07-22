

resource "kubernetes_secret" "argo-postgres-config" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "argo-postgres-config"
    namespace = kubernetes_namespace.bluebird.metadata[0].name
  }

  data = {
    #  "username" = "bluebird@${azurerm_postgresql_server.postgresql_server.name}"
    "username" = "${azurerm_postgresql_flexible_server.sqldb.administrator_login}"
    "password" = "${random_password.password.result}"
  }
  depends_on = [
    random_password.password
  ]
}


#we need to replace ip address



data "template_file" "argo-workflow-controller-configmap" {
  template = <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: workflow-controller-configmap
  namespace: ${var.NAMESPACE}
data:
  parallelism: "20"
  namespaceParallelism: "20"
  resourceRateLimit: |
    limit: 20
    burst: 5
  persistence: |
    archive: true
    # skip database migration if needed.
    # skipMigration: true
    postgresql:
      host: ${azurerm_private_endpoint.postgresql_pe.custom_dns_configs[0].ip_addresses[0]} 
      port: 5432
      database: bluebird_dp
      tableName: argo_workflows
      userNameSecret:
        name: argo-postgres-config
        key: username
      passwordSecret:
        name: argo-postgres-config
        key: password
EOF
  depends_on = [
    azurerm_postgresql_flexible_server.sqldb,
    kubernetes_secret.argo-postgres-config
  ]
}


resource "kubectl_manifest" "argo-workflow-controller-configmap" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  yaml_body = data.template_file.argo-workflow-controller-configmap.rendered
}

data "kubectl_file_documents" "argo-workflow" {
  content = data.template_file.argo-workflow.rendered
}

resource "kubectl_manifest" "argo-workflow" {
  for_each  = var.CREATE_K8S_RESOURCES ? data.kubectl_file_documents.argo-workflow.manifests : {}
  yaml_body = each.value
  depends_on = [
    kubernetes_namespace.bluebird,
    kubectl_manifest.argo-workflow-controller-configmap
  ]
}

data "kubectl_file_documents" "event-bus-native" {
  content = data.template_file.event-bus-template.rendered
}

resource "kubectl_manifest" "event-bus-native" {
  for_each  = var.CREATE_K8S_RESOURCES ? data.kubectl_file_documents.event-bus-native.manifests : {}
  yaml_body = each.value
  depends_on = [
    kubernetes_namespace.bluebird
  ]
}

resource "kubernetes_service_account" "operate-workflow-sa" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "operate-workflow-sa"
    namespace = var.NAMESPACE
  }
  depends_on = [
    kubernetes_namespace.bluebird
  ]
}

data "kubectl_file_documents" "sensor_rbac" {
  content = data.template_file.sensor_rbac-template.rendered
}

resource "kubectl_manifest" "sensor_rbac" {
  for_each  = var.CREATE_K8S_RESOURCES ? data.kubectl_file_documents.sensor_rbac.manifests : {}
  yaml_body = each.value
  depends_on = [
    kubernetes_namespace.bluebird
  ]
}

data "kubectl_file_documents" "workflow_rbac" {
  content = data.template_file.workflow-rbac-template.rendered
}

resource "kubectl_manifest" "workflow_rbac" {
  for_each  = var.CREATE_K8S_RESOURCES ? data.kubectl_file_documents.workflow_rbac.manifests : {}
  yaml_body = each.value
  depends_on = [
    kubernetes_namespace.bluebird
  ]
}

data "kubectl_file_documents" "argo-events" {
  content = data.template_file.argo-events-template.rendered
}

resource "kubectl_manifest" "argo-events" {
  for_each  = var.CREATE_K8S_RESOURCES ? data.kubectl_file_documents.argo-events.manifests : {}
  yaml_body = each.value
  depends_on = [
    kubernetes_namespace.bluebird
  ]
}


