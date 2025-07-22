

data "template_file" "authz-template" {
  template = <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: authz-api
  name: authz-api
  namespace: ${var.NAMESPACE}
spec:
  replicas: 1
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1          # How many pods can be created above the desired amount
      maxUnavailable: 1
  selector:
    matchLabels:
      app: authz-api
  template:
    metadata:
      labels:
        app: authz-api
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
              - matchExpressions:
                  - key: nodes_pool
                    operator: In
                    values:
                      - api
      initContainers:
        - name: prepare-connector-creds
          image: busybox
          command:
            - sh
            - -c
            - |
              mkdir -p /etc/connector-creds
              echo "Checking for files in /tmp/creds"
              ls -al /tmp/creds
              if [ "$(ls -A /tmp/creds)" ]; then
                echo "Files found, creating JSON."
                echo "{" > /etc/connector-creds/all-creds.json
                for f in /tmp/creds/*; do
                  if [ -f "$f" ]; then  # Ensure $f is a file
                    echo "Processing file: $f"
                    echo "\"$(basename "$f")\": \"$(cat "$f")\"," >> /etc/connector-creds/all-creds.json
                  fi
                done
                sed -i '$ s/,$//' /etc/connector-creds/all-creds.json
                echo "}" >> /etc/connector-creds/all-creds.json
              else
                echo "No files found, creating empty JSON."
                echo "{}" > /etc/connector-creds/all-creds.json
              fi
              chmod 777 /etc/connector-creds/all-creds.json
          volumeMounts:
            - name: connector-creds
              mountPath: /tmp/creds
            - name: all-connector-creds
              mountPath: /etc/connector-creds
      containers:
        - envFrom:
            - configMapRef:
                name: authz
            - secretRef:
                name: authz
          image: ${var.AUTHZ_API_IMAGE}
          imagePullPolicy: Always
          livenessProbe:
            failureThreshold: 3
            httpGet:
              path: /authz-api/actuator/health/readiness
              port: 5030
              scheme: HTTP
            initialDelaySeconds: 60
            periodSeconds: 30
            successThreshold: 1
            timeoutSeconds: 10
          name: authz-api
          ports:
            - containerPort: 5030
              name: authz-api
              protocol: TCP
          readinessProbe:
            failureThreshold: 3
            httpGet:
              path: /authz-api/actuator/health/liveness
              port: 5030
              scheme: HTTP
            initialDelaySeconds: 60
            periodSeconds: 30
            successThreshold: 1
            timeoutSeconds: 10
          resources:
            limits:
              cpu: 1500m
              memory: 5000Mi
            requests:
              cpu: 1500m
              memory: 5000Mi
          securityContext:
            runAsUser: 0
            allowPrivilegeEscalation: true
          terminationMessagePath: /dev/termination-log
          terminationMessagePolicy: File
          volumeMounts:
            - mountPath: /secrets_dir
              name: secrets-vol
            - mountPath: /connector-creds
              name: all-connector-creds
      dnsPolicy: ClusterFirst
      imagePullSecrets:
        - name: aws-ecr-creds
      restartPolicy: Always
      securityContext: {}
      serviceAccount: bluebird-admin
      serviceAccountName: bluebird-admin
      terminationGracePeriodSeconds: 30
      tolerations:
        - effect: NoSchedule
          key: nodes_pool
          value: api
      volumes:
        - name: secrets-vol
          secret:
            defaultMode: 420
            items:
              - key: GCP_CEDENTIALS
                path: gcp_creds.json
            secretName: authz
        - name: connector-creds
          secret:
            defaultMode: 420
            secretName: connector-creds-authz
        - name: all-connector-creds
          emptyDir: {}
EOF
}

data "kubectl_file_documents" "authz-api" {
  content = data.template_file.authz-template.rendered
}

resource "kubectl_manifest" "authz-api" {
  for_each         = var.CREATE_K8S_RESOURCES ? data.kubectl_file_documents.authz-api.manifests : {}
  yaml_body        = each.value
  wait_for_rollout = false
  depends_on = [
    kubernetes_namespace.bluebird
  ]
}

