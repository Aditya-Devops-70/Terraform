

data "template_file" "dfx-worker" {
  template = <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dfx-worker
  namespace: ${var.NAMESPACE}
  labels:
    app: dfx-worker
    app_name: dfx-api
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1          # How many pods can be created above the desired amount
      maxUnavailable: 1
  selector:
    matchLabels:
      app: dfx-worker
  template:
    metadata:
      labels:
        app: dfx-worker
        app_name: dfx-api
    spec:
      serviceAccountName: bluebird-admin
      containers:
        - name: dfx-worker
          image: ${var.DFX_WORKER_IMAGE}
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
            - configMapRef:
                name: dfx-api
            - secretRef:
                name: bluebird
            - secretRef:
                name: dfx-api
          livenessProbe:
            exec:
              command:
                - ./worker_liveness.sh
            initialDelaySeconds: 20
            periodSeconds: 10
            timeoutSeconds: 5
            successThreshold: 1
            failureThreshold: 3
          readinessProbe:
            exec:
              command:
                - ./worker_liveness.sh
            initialDelaySeconds: 20
            periodSeconds: 10
            timeoutSeconds: 5
            successThreshold: 1
            failureThreshold: 3
          imagePullPolicy: Always
          resources:
            requests:
              cpu: "3"
              memory: 4500Mi
            limits:
              cpu: "3"
              memory: 4500Mi
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
                      - dfx_worker
      tolerations:
        - key: nodes_pool
          operator: Equal
          value: dfx_worker
          effect: NoSchedule
      dnsPolicy: ClusterFirst
      imagePullSecrets:
        - name: aws-ecr-creds
      restartPolicy: Always
      securityContext: {}
EOF
}

data "kubectl_file_documents" "dfx-worker" {
  content = data.template_file.dfx-worker.rendered
}

resource "kubectl_manifest" "dfx-worker" {
  for_each         = var.CREATE_K8S_RESOURCES ? data.kubectl_file_documents.dfx-worker.manifests : {}
  yaml_body        = each.value
  wait_for_rollout = false
  depends_on = [
    kubernetes_namespace.bluebird,
    kubectl_manifest.dfx-api
  ]
  timeouts {
    create = "15m"
  }
}

