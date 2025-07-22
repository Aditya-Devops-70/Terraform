

resource "kubernetes_secret" "boxyhq-jackson-secrets" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "boxyhq-jackson-secrets"
    namespace = kubernetes_namespace.bluebird.metadata[0].name
  }
  data = {
    "jackson-api-keys"  = random_password.boxyhq-api-key.result
    "nextauth-secret"   = random_password.boxyhq-nextauth-secret.result
    "admin-credentials" = "devops@bluebird.com:${random_password.boxyhq-admin-credentials.result}"
  }
  depends_on = [
    random_password.boxyhq-api-key,
    random_password.boxyhq-admin-credentials,
    random_password.boxyhq-nextauth-secret
  ]
}
# - name: DB_URL
#   value: "postgres://bluebird:${random_password.password.result}@${module.sql-db.private_ip_address}:5432/boxyhq"

data "template_file" "boxyhq" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  template = <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: boxyhq-jackson-deployment
  namespace: ${kubernetes_namespace.bluebird.metadata[0].name}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: boxyhq-jackson
  template:
    metadata:
      labels:
        app: boxyhq-jackson
    spec:
      containers:
      - name: boxyhq-jackson
        image: boxyhq/jackson:1.26.7
        ports:
        - containerPort: 5225
        env:
        - name: DB_ENGINE
          value: "sql"

        - name: DB_TYPE
          value: "postgres"
        - name: DB_URL
          value: "postgres://bluebird:${azurerm_postgresql_flexible_server.sqldb.administrator_password}@${azurerm_private_endpoint.postgresql_pe.custom_dns_configs[0].ip_addresses[0]}:5432/boxyhq"
        - name: NEXTAUTH_URL
          value: "https://auth-${var.APP_DOMAIN}"
        - name: EXTERNAL_URL
          value: "https://auth-${var.APP_DOMAIN}"
        - name: SAML_AUDIENCE
          value: "https://${var.APP_DOMAIN}"
        - name: JACKSON_API_KEYS
          valueFrom:
            secretKeyRef:
              name: boxyhq-jackson-secrets
              key: jackson-api-keys
        - name: HOST
          value: "0.0.0.0"
        - name: HOSTNAME
          value: "0.0.0.0"
        - name: NEXTAUTH_SECRET
          valueFrom:
            secretKeyRef:
              name: boxyhq-jackson-secrets
              key: nextauth-secret
        - name: NEXTAUTH_ADMIN_CREDENTIALS
          valueFrom:
            secretKeyRef:
              name: boxyhq-jackson-secrets
              key: admin-credentials
        readinessProbe:
          httpGet:
            path: /api/health
            port: 5225
          initialDelaySeconds: 10
          periodSeconds: 5
        livenessProbe:
          httpGet:
            path: /api/health
            port: 5225
          initialDelaySeconds: 15
          periodSeconds: 10
EOF
  depends_on = [
    kubernetes_secret.boxyhq-jackson-secrets,
    random_password.password
  ]
}



resource "kubectl_manifest" "boxyhq" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  provider  = kubectl
  yaml_body = data.template_file.boxyhq.rendered
  depends_on = [
    kubernetes_namespace.bluebird,
    kubernetes_secret.boxyhq-jackson-secrets,
    #    module.sql-db,
    azurerm_kubernetes_cluster.aks,
    #    azurerm_kubernetes_cluster_node_pool.dfx_worker_loads_nodes_pool
  ]

}




resource "kubectl_manifest" "boxyhqservice" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  provider  = kubectl
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  name: boxyhq-jackson-service
  namespace: ${kubernetes_namespace.bluebird.metadata[0].name}
spec:
  selector:
    app: boxyhq-jackson
  ports:
    - protocol: TCP
      port: 5225
      targetPort: 5225
YAML
  depends_on = [
    kubectl_manifest.boxyhq,
    azurerm_kubernetes_cluster.aks
  ]
}

