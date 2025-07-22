

data "template_file" "blui" {
  template = <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: blui
  namespace: ${var.NAMESPACE}
  labels:
    app: blui
    app_name: blui
spec:
  replicas: 2
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
  selector:
    matchLabels:
      app: blui
  template:
    metadata:
      labels:
        app: blui
        app_name: blui
    spec:
      serviceAccountName: bluebird-admin
      containers:
        - name: blui
          image: ${var.BLUI_IMAGE}
          ports:
            - containerPort: 3000
              name: blui
              protocol: TCP
          envFrom:
            - configMapRef:
                name: bluebird-blui
            - secretRef:
                name: bluebird-blui
          livenessProbe:
            httpGet:
              path: /status
              port: 3000
              scheme: HTTP
            initialDelaySeconds: 10
            periodSeconds: 30
            successThreshold: 1
            timeoutSeconds: 10
            failureThreshold: 3
          readinessProbe:
            httpGet:
              path: /status
              port: 3000
              scheme: HTTP
            initialDelaySeconds: 10
            periodSeconds: 30
            successThreshold: 1
            timeoutSeconds: 10
            failureThreshold: 3
          resources:
            limits:
              cpu: 1500m
              memory: 5000Mi
            requests:
              cpu: 1500m
              memory: 5000Mi
          securityContext:
            allowPrivilegeEscalation: true
          terminationMessagePath: /dev/termination-log
          terminationMessagePolicy: File
          imagePullPolicy: Always
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
              - matchExpressions:
                  - key: nodes_pool
                    operator: In
                    values:
                      - api
      tolerations:
        - key: nodes_pool
          operator: Equal
          value: api
          effect: NoSchedule
      dnsPolicy: ClusterFirst
      imagePullSecrets:
        - name: aws-ecr-creds
      restartPolicy: Always
      securityContext: {}

EOF
}

data "kubectl_file_documents" "blui" {
  content = data.template_file.blui.rendered
}

resource "kubectl_manifest" "blui" {
  for_each         = var.CREATE_K8S_RESOURCES ? data.kubectl_file_documents.blui.manifests : {}
  yaml_body        = each.value
  wait_for_rollout = false
  depends_on = [
    kubernetes_namespace.bluebird,
    kubectl_manifest.data-plane-api,
    kubectl_manifest.dfx-api,
    kubectl_manifest.dfx-worker
  ]
}

