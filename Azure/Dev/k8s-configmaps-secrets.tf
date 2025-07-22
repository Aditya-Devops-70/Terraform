

resource "kubernetes_config_map" "authz" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "authz"
    namespace = kubernetes_namespace.bluebird.metadata[0].name
  }

  data = {
    SPRING_DATASOURCE_USERNAME = "bluebird"
    #    SPRING_DATASOURCE_URL                         = "jdbc:postgresql://${module.sql-db.private_ip_address}:5432/authz?currentSchema=bluebird_authz"
    BOXYHQ_PUBLIC_URL      = "https://auth-${var.APP_DOMAIN}/api"
    BOXYHQ_API_URL         = "http://boxyhq-jackson-service.${kubernetes_namespace.bluebird.metadata[0].name}.svc.cluster.local:5225/api"
    AWS_ENABLED            = var.AWS_ENABLED
    BOXYHQ_ENABLED         = var.BOXYHQ_ENABLED
    WORKOS_ENABLED         = var.WORKOS_ENABLED
    JWS_SERVICE            = var.JWS_SERVICE
    SPRING_PROFILES_ACTIVE = "cloudsql"
    #    SPRING_CLOUD_GCP_SQL_INSTANCE_CONNECTION_NAME = module.sql-db.instance_connection_name
    CONNECTORS_OAUTH_SECRETS_TYPE  = var.CONNECTORS_OAUTH_SECRETS_TYPE
    GOOGLE_APPLICATION_CREDENTIALS = "/secrets_dir/gcp_creds.json"
    #    GCP_PROJECT_ID = var.PROJECT_ID
    GCP_LOCATION_ID             = var.REGION
    GCP_JWT_KEY_RING_ID         = azurerm_key_vault.key_vault.name
    GCP_JWT_AUTH_KEY_ID         = azurerm_key_vault_key.auth_key.name
    GCP_JWT_AUTH_KEY_VERSION    = var.GCP_JWT_AUTH_KEY_VERSION
    GCP_JWT_REFRESH_KEY_ID      = azurerm_key_vault_key.refresh_key.name
    GCP_JWT_REFRESH_KEY_VERSION = var.GCP_JWT_REFRESH_KEY_VERSION
    #CONNECTORS_OAUTH_SECRETS_K8S_PATH = "/connector-creds/all-creds.json"
  }
  depends_on = [
    # module.sql-db
    azurerm_postgresql_flexible_server.sqldb
  ]
}

resource "kubernetes_secret" "authz" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "authz"
    namespace = kubernetes_namespace.bluebird.metadata[0].name
  }

  data = {
    "SPRING_DATASOURCE_PASSWORD" = "${random_password.password.result}"
    "BOXYHQ_API_KEY"             = "${random_password.boxyhq-api-key.result}"
    #  "GCP_CEDENTIALS"             = base64decode(google_service_account_key.bluebird-sa_key.private_key)
  }
  depends_on = [
    azurerm_kubernetes_cluster.aks,
    random_password.password,
    random_password.boxyhq-api-key,
    #    google_service_account_key.bluebird-sa_key
  ]
}

resource "kubernetes_config_map" "bluebird" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "bluebird"
    namespace = kubernetes_namespace.bluebird.metadata[0].name
    labels = {
      "workflows.argoproj.io/configmap-type" = "Parameter"
    }
  }

  data = {
    SPRING_DATASOURCE_USERNAME = "bluebird"
    #    SPRING_DATASOURCE_URL                         = "jdbc:postgresql://${module.sql-db.private_ip_address}:5432/bluebird_dp?currentSchema=bluebird_dp"
    BLOB_STORE_PATH  = "gs://${azurerm_storage_account.stage_out.name}"
    BLOB_BUCKET_NAME = azurerm_storage_account.stage_out.name
    #  BLOB_LOG_BUCKET_NAME = azurerm_storage_account.log_bucket.name
    #    GCP_PROJECT_ID                                = var.PROJECT_ID
    #    SPRING_CLOUD_GCP_SQL_INSTANCE_CONNECTION_NAME = module.sql-db.instance_connection_name
    #    DATASET_DATABASE                              = var.PROJECT_ID
    DATASET_SCHEMA                            = var.DATASET_SCHEMA
    K8S_NAMESPACE                             = "bluebird"
    K8S_CONFIGMAP_NAME                        = "bluebird"
    K8S_DATA_PVC                              = "data-volume-claim"
    K8S_DATA_INTEGRATION_PVC                  = "data-volume-claim"
    LOGGING_LEVEL_ROOT                        = "INFO"
    CLOUD_HOST                                = "AZURE"
    SPRING_PROFILES_ACTIVE                    = "cloudsql" #needs to be replace
    GOOGLE_APPLICATION_CREDENTIALS            = "/secrets_dir/gcp_creds.json"
    SPRING_CLOUD_GCP_SQL_CREDENTIALS_LOCATION = "file:/secrets_dir/gcp_creds.json"
    DEPLOYMENT_ENV                            = "dev"
    FILE_STORE_PATH                           = "/var/bluebird/datasets"
    CATALOG_URL                               = "http://data-plane-api-svc/data-plane-api"
    WORKFLOW_URL                              = "http://data-plane-api-svc/data-plane-api"
    ARGO_API_URL                              = "https://argo-server.${kubernetes_namespace.bluebird.metadata[0].name}.svc.cluster.local:2746"
    DATASET_LOCATION                          = var.REGION
    OTEL_EXPORTER_OTLP_ENDPOINT               = "http://gcpcloud-otel-collector.${kubernetes_namespace.bluebird.metadata[0].name}.svc.cluster.local:4317"
    NATS_SERVER                               = "nats://nats.${kubernetes_namespace.bluebird.metadata[0].name}.svc.cluster.local:4222"
    TEMPORAL_SERVER                           = "http://temporal-frontend.${kubernetes_namespace.bluebird.metadata[0].name}.svc.cluster.local:7233"
    NOTIFICATIONS_ENABLED                     = var.NOTIFICATIONS_ENABLED
    NOTIFICATIONS_SKIP_EMAIL_VERIFICATION     = var.NOTIFICATIONS_SKIP_EMAIL_VERIFICATION
    APPURL                                    = "https://${var.APP_DOMAIN}"
    SPRING_MAIL_SENDER                        = var.SPRING_MAIL_SENDER
    SPRING_MAIL_USERNAME                      = var.SPRING_MAIL_USERNAME
    SPRING_MAIL_HOST                          = var.SPRING_MAIL_HOST
    SPRING_MAIL_PASSWORD                      = var.SPRING_MAIL_PASSWORD
    SPRING_MAIL_PORT                          = var.SPRING_MAIL_PORT
    DOCX_TEMPLATOR_SERVER                     = "http://docx-templator.${kubernetes_namespace.bluebird.metadata[0].name}.svc.cluster.local"
    GOTENBERG_SERVER                          = "http://gotenberg.${kubernetes_namespace.bluebird.metadata[0].name}.svc.cluster.local/forms/libreoffice/convert"
    PUSHER_ENABLED                            = var.PUSHER_ENABLED
    #    COLLECTION_DB_HOST                            = module.sql-db.private_ip_address
    COLLECTION_DB_PORT                  = 5432
    COLLECTION_DB_USER                  = "bluebird"
    COLLECTION_DB_DATABASE              = "bluebird_dp"
    COLLECTION_DB_SCHEMA                = "copa_collections"
    PROCESS_COLLECTION_DB_CONNECT       = true
    MESSAGING_SERVER                    = var.MESSAGING_SERVER
    CENTRIFUGO_URL                      = "http://centrifugo-service.${kubernetes_namespace.bluebird.metadata[0].name}.svc.cluster.local:8000"
    AUTHZ_URL                           = "http://authz-api-svc/authz-api"
    APP_LABEL_KEY                       = "app_name"
    IMAGES_DBT_BIGQUERY                 = var.DBT_IMAGE_BIGQUERY
    SYSTEM_CONNECTOR_ENABLE_COLLECTIONS = var.SYSTEM_CONNECTOR_ENABLE_COLLECTIONS
    #    SYSTEM_CONNECTOR_HOST = module.sql-db.private_ip_address
    SYSTEM_CONNECTOR_PORT     = 5432
    SYSTEM_CONNECTOR_DATABASE = "bluebird_dp"
    SYSTEM_CONNECTOR_SCHEMA   = "bluebird_dp"
    SYSTEM_CONNECTOR_SCHEDULE = var.SYSTEM_CONNECTOR_SCHEDULE
    SYSTEM_CONNECTOR_USER     = "bluebird"
    GMAIL_OAUTH_CLIENT_ID     = var.GMAIL_OAUTH_CLIENT_ID
  }
  depends_on = [
    #    module.sql-db,
    azurerm_kubernetes_cluster.aks
  ]
}

resource "kubernetes_secret" "bluebird" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "bluebird"
    namespace = kubernetes_namespace.bluebird.metadata[0].name
    labels = {
      "workflows.argoproj.io/configmap-type" = "Parameter"
    }
  }

  data = {
    "SPRING_DATASOURCE_PASSWORD" = "${random_password.password.result}"
    #    "GCP_CEDENTIALS"             = "${base64decode(google_service_account_key.bluebird-sa_key.private_key)}"
    "K8S_SECRETS_NAME"        = "bluebird"
    PUSHER_APP_ID             = "'"
    PUSHER_KEY                = ""
    PUSHER_SECRET             = "'"
    PUSHER_CLUSTER            = ""
    pusher_pusherKey          = ""
    pusher_pusherSecret       = ""
    pusher_pusherCluster      = ""
    pusher_pusherId           = ""
    CLAUDE_ANTHROPIC_API_KEY  = ""
    COLLECTION_DB_PASSWORD    = "${random_password.password.result}"
    CENTRIFUGO_API_KEY        = "${random_password.centrifugo_api_key.result}"
    SYSTEM_CONNECTOR_PASSWORD = "${random_password.password.result}"
    GMAIL_OAUTH_CLIENT_SECRET = var.GMAIL_OAUTH_CLIENT_SECRET
  }
  depends_on = [
    azurerm_kubernetes_cluster.aks,
    random_password.password,
    #    google_service_account_key.bluebird-sa_key,
    random_password.centrifugo_api_key
  ]
}

resource "kubernetes_config_map" "data-plane-api" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "data-plane-api"
    namespace = kubernetes_namespace.bluebird.metadata[0].name
  }
  lifecycle {
    ignore_changes = [
      data
    ]
  }
}

resource "kubernetes_secret" "data-plane-api" {
  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "data-plane-api"
    namespace = kubernetes_namespace.bluebird.metadata[0].name
  }
  data = {
    "SPRING_DATASOURCE_PASSWORD" = "${random_password.password.result}"
    #    "GCP_CEDENTIALS"             = "${base64decode(google_service_account_key.bluebird-sa_key.private_key)}"
  }
  lifecycle {
    ignore_changes = [
      data
    ]
  }
  depends_on = [
    azurerm_kubernetes_cluster.aks,
    random_password.password,
    #    google_service_account_key.bluebird-sa_key
  ]
}

resource "kubernetes_config_map" "dfx-api" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "dfx-api"
    namespace = kubernetes_namespace.bluebird.metadata[0].name
  }
  lifecycle {
    ignore_changes = [
      data
    ]
  }
}

resource "kubernetes_config_map" "notifications" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "notifications"
    namespace = kubernetes_namespace.bluebird.metadata[0].name
  }
  lifecycle {
    ignore_changes = [
      data
    ]
  }
}

resource "kubernetes_secret" "dfx-api" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "dfx-api"
    namespace = kubernetes_namespace.bluebird.metadata[0].name
  }
  data = {
    #    "GCP_CEDENTIALS" = "${base64decode(google_service_account_key.bluebird-sa_key.private_key)}"
  }
  lifecycle {
    ignore_changes = [
      data
    ]
  }
}

resource "kubernetes_config_map" "data-pipelines" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "data-pipelines"
    namespace = kubernetes_namespace.bluebird.metadata[0].name
    labels = {
      "workflows.argoproj.io/configmap-type" = "Parameter"
    }
  }
  lifecycle {
    ignore_changes = [
      data
    ]
  }
}

resource "kubernetes_secret" "data-pipelines" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "data-pipelines"
    namespace = kubernetes_namespace.bluebird.metadata[0].name
    labels = {
      "workflows.argoproj.io/configmap-type" = "Parameter"
    }
  }
  lifecycle {
    ignore_changes = [
      data
    ]
  }
}

resource "kubernetes_secret" "webhook" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "webhook"
    namespace = kubernetes_namespace.bluebird.metadata[0].name
  }
  lifecycle {
    ignore_changes = [
      data
    ]
  }
}

resource "kubernetes_secret" "bluebird-sa_key_secret" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "blu-sa-key"
    namespace = kubernetes_namespace.bluebird.metadata[0].name
  }
  data = {
    #    "service-account-key.json" = base64decode(google_service_account_key.bluebird-sa_key.private_key)
  }
  type = "Opaque"
  #  depends_on = [google_service_account_key.bluebird-sa_key]
}

resource "kubernetes_secret" "image-pull-secret" {
  #    count = var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "aws-ecr-creds"
    namespace = kubernetes_namespace.bluebird.metadata[0].name
  }

  data = {
    ".dockerconfigjson" = "{}"
  }
  type = "kubernetes.io/dockerconfigjson"
  lifecycle {
    ignore_changes = [
      data
    ]
  }
  depends_on = [
    kubernetes_namespace.bluebird
  ]
}



# Data source to get the latest secret version from Azure Key Vault
data "azurerm_key_vault_secret" "connector_creds_latest" {
  name         = azurerm_key_vault_secret.connector_creds_version.name # Secret name in Key Vault
  key_vault_id = azurerm_key_vault.connector-creds.id                  # Reference to the Key Vault resource
}

# Local variable to parse the secret value (assuming it's a JSON object)
locals {
  #  parsed_secret_data_connector_creds = jsondecode(data.azurerm_key_vault_secret.connector_creds_latest.value)
}






resource "kubernetes_secret" "connector-creds" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = azurerm_key_vault.connector-creds.name
    namespace = kubernetes_namespace.bluebird.metadata[0].name
  }
  data = {
    #    for key, value in local.parsed_secret_data_connector_creds : key => base64decode(value)
  }
  depends_on = [
    #google_secret_manager_secret.connector-creds,
    azurerm_key_vault.connector-creds,
    #azurerm_key_vault_secret.connector_creds_version

    #google_secret_manager_secret_version.connector-creds-version
  ]
}







data "azurerm_key_vault_secret" "connector-creds-authz-latest" {
  name         = azurerm_key_vault_secret.connector_creds_authz_version.name
  key_vault_id = azurerm_key_vault.connector-creds-authz.id
  #  version = "latest"
  depends_on = [
    #    google_secret_manager_secret_version.connector-creds-authz-version
    azurerm_key_vault_secret.connector_creds_authz_version
  ]
}

locals {
  #  parsed_secret_data_connector_creds_authz = jsondecode(data.azurerm_key_vault_secret.connector-creds-authz-latest.value)
}






resource "kubernetes_secret" "connector-creds-authz" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "connector-creds-authz"
    namespace = kubernetes_namespace.bluebird.metadata[0].name
  }
  data = {
    #  for key, value in local.parsed_secret_data_connector_creds_authz : key => base64decode(value)
  }
  depends_on = [
    #    google_secret_manager_secret.connector-creds-authz,
    #    google_secret_manager_secret_version.connector-creds-authz-version
  ]
}








resource "kubernetes_secret" "observability" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "observability"
    namespace = kubernetes_namespace.bluebird.metadata[0].name
  }
  data = {
    #    "GCP_CREDENTIALS"             = "${base64decode(google_service_account_key.bluebird-sa_key.private_key)}"
  }
}

resource "kubernetes_config_map" "bluebird-blui" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "bluebird-blui"
    namespace = kubernetes_namespace.bluebird.metadata[0].name
  }

  data = {
    NODE_TLS_REJECT_UNAUTHORIZED = 0
    ADMIN_EMAIL                  = "support@bluebird.com"
    GRDIVE_APP_ID                = ""
    ONEDRIVE_CLIENT_ID           = ""
    MAX_PIVOT_CELL_COUNT         = "20000"
    SHOULD_LOG_INFO_CURL         = false
    MAX_LINES_FOR_REPORT_CHART   = "100"
    SHOULD_SHOW_MODEL            = true
    ROW_LIMIT                    = "5000"
    DBT_TRANSFORMATIONS_BRANCH   = var.DBT_BRANCH
    ORG_ID                       = var.BOXY_CLIENT_ID
    WEBSOCKET_MECHANISM          = "centrifugo"
    CENTRIFUGO_WEBSOCKET_URL     = "wss://pusher-${var.APP_DOMAIN}/connection/websocket"
    bluebird_API_URL             = "http://data-plane-api-svc/data-plane-api"
    WORKBOOK_API_ENDPOINT        = "http://dfx-api-svc/dfx"
    AUTHZ_API_URL                = "http://authz-api-svc/authz-api"
    AUTH_SERVICE_TYPE            = "BOXY_HQ"
    CONNECTOR_AUTHZ_API_URL      = var.CONNECTOR_AUTHZ_API_URL == "" ? "http://authz-api-svc/authz-api" : var.CONNECTOR_AUTHZ_API_URL
  }
}

resource "kubernetes_secret" "bluebird-blui" {
  #  count = var.CREATE_K8S_RESOURCES ? 1 : 0
  metadata {
    name      = "bluebird-blui"
    namespace = kubernetes_namespace.bluebird.metadata[0].name
  }

  data = {
    AGGRID_LICENSE_KEY = var.AGGID_LICENSE_KEY
    GDRIVE_API_KEY     = ""
  }
}


