

resource "kubernetes_secret" "temporal-postgres-config" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "temporal-postgres-config"
    namespace = kubernetes_namespace.bluebird.metadata[0].name
  }

  data = {
    "password" = "${random_password.password.result}"
  }
  depends_on = [
    random_password.password
  ]
}

resource "helm_release" "temporal" {
  count     = var.CREATE_K8S_RESOURCES ? 1 : 0
  name      = "temporal"
  chart     = "temporal-0.33.0.tgz"
  namespace = kubernetes_namespace.bluebird.metadata[0].name
  timeout   = 1800
  set {
    name  = "fullnameOverride"
    value = "temporal"
  }
  set {
    name  = "server.replicaCount"
    value = "2"
  }
  set {
    name  = "server.config.persistence.default.driver"
    value = "sql"
  }
  set {
    name  = "server.config.persistence.default.sql.driver"
    value = "postgres"
  }
  set {
    name  = "server.config.persistence.default.sql.host"
    value = azurerm_private_endpoint.postgresql_pe.custom_dns_configs[0].ip_addresses[0]
  }
  set {
    name  = "server.config.persistence.default.sql.port"
    value = "5432"
  }
  set {
    name  = "server.config.persistence.default.sql.user"
    value = azurerm_postgresql_flexible_server.sqldb.administrator_login
  }
  set {
    name  = "server.config.persistence.default.sql.existingSecret"
    value = kubernetes_secret.temporal-postgres-config.metadata[0].name
  }
  set {
    name  = "server.config.persistence.default.sql.secretName"
    value = kubernetes_secret.temporal-postgres-config.metadata[0].name
  }
  set {
    name  = "server.config.persistence.visibility.driver"
    value = "sql"
  }
  set {
    name  = "server.config.persistence.visibility.sql.driver"
    value = "postgres"
  }
  set {
    name  = "server.config.persistence.visibility.sql.host"
    value = azurerm_private_endpoint.postgresql_pe.custom_dns_configs[0].ip_addresses[0]
  }
  set {
    name  = "server.config.persistence.visibility.sql.port"
    value = "5432"
  }
  set {
    name  = "server.config.persistence.visibility.sql.user"
    value = azurerm_postgresql_flexible_server.sqldb.administrator_login
  }
  set {
    name  = "server.config.persistence.visibility.sql.existingSecret"
    value = kubernetes_secret.temporal-postgres-config.metadata[0].name
  }
  set {
    name  = "server.config.persistence.visibility.sql.secretName"
    value = kubernetes_secret.temporal-postgres-config.metadata[0].name
  }
  set {
    name  = "elasticsearch.enabled"
    value = "false"
  }
  set {
    name  = "prometheus.enabled"
    value = "false"
  }
  set {
    name  = "grafana.enabled"
    value = "false"
  }
  set {
    name  = "cassandra.enabled"
    value = "false"
  }

  set {
    name  = "admintools.tolerations[0].effect"
    value = "NoSchedule"
  }
  set {
    name  = "admintools.tolerations[0].key"
    value = "nodes_pool"
  }
  set {
    name  = "admintools.tolerations[0].value"
    value = "static"
  }

  set {
    name  = "admintools.nodeSelector.nodes_pool"
    value = "static"
  }

  set {
    name  = "web.tolerations[0].effect"
    value = "NoSchedule"
  }
  set {
    name  = "web.tolerations[0].key"
    value = "nodes_pool"
  }
  set {
    name  = "web.tolerations[0].value"
    value = "static"
  }
  set {
    name  = "web.nodeSelector.nodes_pool"
    value = "static"
  }

  set {
    name  = "server.tolerations[0].effect"
    value = "NoSchedule"
  }
  set {
    name  = "server.tolerations[0].key"
    value = "nodes_pool"
  }
  set {
    name  = "server.tolerations[0].value"
    value = "static"
  }
  set {
    name  = "server.nodeSelector.nodes_pool"
    value = "static"
  }

  depends_on = [
    random_password.password
  ]

}

