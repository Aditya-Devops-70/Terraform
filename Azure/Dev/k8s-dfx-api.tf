

data "template_file" "dfx-api" {
  template = <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dfx-api
  namespace: ${var.NAMESPACE}
  labels:
    app: dfx-api
    app_name: dfx-api
spec:
  replicas: 2
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1          # How many pods can be created above the desired amount
      maxUnavailable: 1
  selector:
    matchLabels:
      app: dfx-api
  template:
    metadata:
      labels:
        app: dfx-api
        app_name: dfx-api
    spec:
      serviceAccountName: bluebird-admin
      containers:
        - name: dfx-api-deploy-gcp
          image: ${var.DFX_API_IMAGE}
          ports:
            - containerPort: 5000
              protocol: TCP
          env:
            - name: DATAPLANE_CLIENT_TOKEN
              valueFrom:
                secretKeyRef:
                  name: dfx-api
                  key: data-plane-client-token
          envFrom:
            - configMapRef:
                name: bluebird
            - secretRef:
                name: dfx-api
            - secretRef:
                name: bluebird
          livenessProbe:
            httpGet:
              path: /dfx/
              port: 5000
              scheme: HTTP
            initialDelaySeconds: 20
            periodSeconds: 30
            timeoutSeconds: 20
            successThreshold: 1
            failureThreshold: 5
          readinessProbe:
            httpGet:
              path: /dfx/
              port: 5000
              scheme: HTTP
            initialDelaySeconds: 20
            periodSeconds: 30
            timeoutSeconds: 20
            successThreshold: 1
            failureThreshold: 5
          resources:
            requests:
              cpu: 1500m
              memory: 5000Mi
            limits:
              cpu: 1500m
              memory: 5000Mi
          securityContext:
            allowPrivilegeEscalation: true
          terminationMessagePath: /dev/termination-log
          terminationMessagePolicy: File
          volumeMounts:
            - mountPath: /secrets_dir
              name: secrets-vol
            - mountPath: /var/bluebird/datasets
              name: file-store
      volumes:
        - name: secrets-vol
          secret:
            secretName: bluebird
            items:
              - key: GCP_CEDENTIALS
                path: gcp_creds.json
        - name: file-store
          persistentVolumeClaim:
            claimName: data-volume-claim
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

data "kubectl_file_documents" "dfx-api" {
  content = data.template_file.dfx-api.rendered
}

resource "kubectl_manifest" "dfx-api" {
  for_each         = var.CREATE_K8S_RESOURCES ? data.kubectl_file_documents.dfx-api.manifests : {}
  yaml_body        = each.value
  wait_for_rollout = false
  depends_on = [
    kubernetes_namespace.bluebird,
    kubectl_manifest.data-plane-api
  ]
  timeouts {
    create = "15m"
  }
}

