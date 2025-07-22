

data "template_file" "data-plane-template" {
  template = <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: data-plane-api
  namespace: ${var.NAMESPACE}
  labels:
    app: data-plane-api
    app_name: data-plane-api
spec:
  replicas: 2
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1          # How many pods can be created above the desired amount
      maxUnavailable: 1
  selector:
    matchLabels:
      app: data-plane-api
  template:
    metadata:
      labels:
        app: data-plane-api
        app_name: data-plane-api
    spec:
      serviceAccountName: bluebird-admin
      containers:
        - name: data-plane-api-deploy-gcp
          image: ${var.DATA_PLANE_API_IMAGE}
          ports:
            - containerPort: 5010
              protocol: TCP
          envFrom:
            - configMapRef:
                name: bluebird
            - secretRef:
                name: bluebird
          resources:
            requests:
              cpu: "1"
              memory: 4Gi
            limits:
              cpu: "1"
              memory: 4Gi
          livenessProbe:
            httpGet:
              path: /data-plane-api/actuator/health/readiness
              port: 5010
              scheme: HTTP
            initialDelaySeconds: 150
            periodSeconds: 30
            timeoutSeconds: 1
            successThreshold: 1
            failureThreshold: 3
          readinessProbe:
            httpGet:
              path: /data-plane-api/actuator/health/liveness
              port: 5010
              scheme: HTTP
            initialDelaySeconds: 150
            periodSeconds: 30
            timeoutSeconds: 1
            successThreshold: 1
            failureThreshold: 3
          imagePullPolicy: Always
          securityContext:
            allowPrivilegeEscalation: true
          terminationMessagePath: /dev/termination-log
          terminationMessagePolicy: File
          volumeMounts:
            - mountPath: /secrets_dir
              name: secrets-vol
      volumes:
        - name: secrets-vol
          secret:
            secretName: bluebird
            items:
              - key: GCP_CEDENTIALS
                path: gcp_creds.json
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      securityContext: {}
      imagePullSecrets:
        - name: aws-ecr-creds
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
EOF
}

data "kubectl_file_documents" "data-plane-api" {
  content = data.template_file.data-plane-template.rendered
}

resource "kubectl_manifest" "data-plane-api" {
  for_each         = var.CREATE_K8S_RESOURCES ? data.kubectl_file_documents.data-plane-api.manifests : {}
  yaml_body        = each.value
  wait_for_rollout = false
  depends_on = [
    kubernetes_namespace.bluebird,
    kubectl_manifest.authz-api
  ]
  timeouts {
    create = "15m"
  }
}

