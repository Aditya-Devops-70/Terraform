

resource "helm_release" "otel-collector" {
  count      = var.CREATE_K8S_RESOURCES ? 1 : 0
  name       = "otel-collector"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-collector"
  namespace  = kubernetes_namespace.bluebird.metadata[0].name
  version    = "v0.77.0"
  timeout    = 1800

  set {
    name  = "fullnameOverride"
    value = "azure-otel-collector"
  }
  set {
    name  = "mode"
    value = "deployment"
  }

  set {
    name  = "autoscaling.enabled"
    value = "true"
  }
  set {
    name  = "autoscaling.minReplicas"
    value = "4"
  }
  set {
    name  = "autoscaling.maxReplicas"
    value = "4"
  }

  #   set {
  #     name  = "extraVolumeMounts[0].mountPath"
  #     value = "/secrets_dir"
  #   }

  #   set {
  #     name  = "extraVolumeMounts[0].name"
  #     value = "secrets-vol"
  #   }

  #   set {
  #     name  = "extraVolumes[0].name"
  #     value = "secrets-vol"
  #   }

  #   set {
  #     name  = "extraVolumes[0].secret.secretName"
  #     value = "observability"
  #   }

  #   set {
  #     name  = "extraVolumes[0].secret.items[0].key"
  #     value = "GCP_CREDENTIALS"
  #   }

  #   set {
  #     name  = "extraVolumes[0].secret.items[0].path"
  #     value = "gcp_creds.json"
  #   }

  #   set {
  #     name  = "extraEnvs[0].name"
  #     value = "GOOGLE_APPLICATION_CREDENTIALS"
  #   }

  #   set {
  #     name  = "extraEnvs[0].value"
  #     value = "/secrets_dir/gcp_creds.json"
  #   }

  #   set {
  #     name  = "config.exporters.googlecloud.project"
  #     value = "${var.PROJECT_ID}"
  #   }

  #   set {
  #     name  = "config.exporters.otlp.endpoint"
  #     value = "ingest.in.signoz.cloud:443"
  #   }

  #   set {
  #     name  = "config.exporters.otlp.tls.insecure"
  #     value = "false"
  #   }

  #   set {
  #     name  = "config.exporters.otlp.headers.signoz-access-token"
  #     value = "4fd78741-d233-4f5b-81dc-6f8cbe8f34ab"
  #   }

  #   set {
  #     name  = "config.exporters.googlecloud.log.default_log_name"
  #     value = "opentelemetry.io/collector-exported-log"
  #   }

  #   set {
  #     name  = "config.service.pipelines.traces.exporters[0]"
  #     value = ""       #we need to change as azure specific
  #   }


  #   set {
  #     name  = "config.service.pipelines.logs.exporters[0]"
  #     value = "googlecloud"
  #   }

  set {
    name  = "tolerations[0].effect"
    value = "NoSchedule"
  }
  set {
    name  = "tolerations[0].key"
    value = "nodes_pool"
  }
  set {
    name  = "tolerations[0].value"
    value = "static"
  }

  depends_on = [
    #    google_project_service.cloudtrace,
    #    google_project_service.cloudlogging
  ]
}

