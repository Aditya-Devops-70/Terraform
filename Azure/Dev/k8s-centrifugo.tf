

data "template_file" "centrifugo_template_file" {
  #    count = var.CREATE_K8S_RESOURCES ? 1 : 0
  template = <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: centrifugo
  namespace: ${kubernetes_namespace.bluebird.metadata[0].name}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: centrifugo
  template:
    metadata:
      labels:
        app: centrifugo
    spec:
      containers:
        - name: centrifugo
          image: centrifugo/centrifugo:v5.0.0
          command:
            - centrifugo
          args:
            - --health
            - --admin=true
          ports:
            - containerPort: 8000
          env:
            - name: CENTRIFUGO_TOKEN_HMAC_SECRET_KEY
              value: "${random_password.centrifugo_hmac_secret.result}"
            - name: CENTRIFUGO_API_KEY
              value: "${random_password.centrifugo_api_key.result}"
            - name: CENTRIFUGO_ADMIN_PASSWORD
              value: "${random_password.centrifugo_admin_password.result}"
            - name: CENTRIFUGO_ADMIN_SECRET
              value: "${random_password.centrifugo_admin_secret.result}"
            - name: CENTRIFUGO_ADMIN
              value: "true"
            - name: CENTRIFUGO_ALLOWED_ORIGINS
              value: '*'
            - name: CENTRIFUGO_HISTORY_SIZE
              value: "10000"
            - name: CENTRIFUGO_HISTORY_TTL
              value: 60m
            - name: CENTRIFUGO_ALLOW_SUBSCRIBE_FOR_CLIENT
              value: "true"
            - name: CENTRIFUGO_TOKEN_RSA_PUBLIC_KEY
              value: "${var.CENTRIFUGO_TOKEN_RSA_PUBLIC_KEY}"
          readinessProbe:
            httpGet:
              path: /health
              port: 8000
            initialDelaySeconds: 10
            periodSeconds: 5
          livenessProbe:
            httpGet:
              path: /health
              port: 8000
            initialDelaySeconds: 15
            periodSeconds: 10
EOF
  depends_on = [
    random_password.centrifugo_hmac_secret,
    random_password.centrifugo_api_key,
    random_password.centrifugo_admin_password,
    random_password.centrifugo_admin_secret
  ]
}


resource "kubectl_manifest" "centrifugo" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  yaml_body = data.template_file.centrifugo_template_file.rendered
  depends_on = [
    kubernetes_namespace.bluebird,
    azurerm_kubernetes_cluster.aks,
    #  google_container_cluster.gke,
    #  azurerm_azurerm_kubernetes_cluster_node_pool.default_loads_nodes_pool
  ]
}

resource "kubectl_manifest" "centrifugo-service" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  yaml_body = <<EOF
apiVersion: v1
kind: Service
metadata:
  name: centrifugo-service
  namespace: ${kubernetes_namespace.bluebird.metadata[0].name}
spec:
  selector:
    app: centrifugo
  ports:
    - protocol: TCP
      port: 8000
      targetPort: 8000
EOF
  depends_on = [
    kubectl_manifest.centrifugo,
    #  google_container_cluster.gke,
    azurerm_kubernetes_cluster.aks
  ]
}

