# variable "PROJECT_ID" {
#   type = string
# }

variable "resource_group_location" {
  type        = string
  default     = "Central India"
  description = "Location of the resource group."
}
variable "INSTANCE_NAME_PREFIX" {
  type    = string
  default = "blcdev"
}

variable "subnet-1" {
  default = "bluebird_subnet_1"
}

variable "nat_ip" {
  default = "bluebird-NAT"
}
variable "nat_gateway" {
  default = "bluebird-nat_gateway"
}

variable "log_bucket_name" {
  default = "logbucketnewe"
}

variable "bucket_name" {
  default = "bluebird70"
}

variable "REGION" {
  type    = string
  default = "Central India"
}
variable "DB_PUBLIC" {
  type    = bool
  default = false
}
variable "DATASET_SCHEMA" {
  type    = string
  default = "bluebird_prod_silver"
}
variable "INSTANCE_NAME" {
  type    = string
  default = "bluebird_dev"
}
variable "GOOGLE_APPLICATION_CREDENTIALS" {
  type    = string
  default = ""
}
variable "FILESTORE_CAPACITY" {
  type    = number
  default = 1024
}
variable "containerregistry1" {
  default = "bluebirdcontainer"
}

variable "DB_TIER" {
  type    = string
  default = "db-custom-2-8192"
}
variable "DFX_WORKER_INSTANCE_CLASS" {
  type    = string
  default = "n2d-custom-4-8192"
}
variable "API_INSTANCE_CLASS" {
  type    = string
  default = "n2d-standard-2"
}
variable "STATIC_INSTANCE_CLASS" {
  type    = string
  default = "n2d-standard-2"
}
variable "JOBS_LOADS_INSTANCE_CLASS" {
  type    = string
  default = "n2d-highmem-8"
}
variable "PROXY_VM_INSTANCE_CLASS" {
  default = "n2d-standard-2"
  type    = string
}

variable "PRIVATE_IP_ADDRESS" {
  type    = string
  default = "" # or any valid IP within the range 10.128.10.0/24
}


variable "NAMESPACE" {
  type    = string
  default = "bluebird"
}
variable "NOTIFICATIONS_ENABLED" {
  type    = bool
  default = false
}
variable "NOTIFICATIONS_SKIP_EMAIL_VERIFICATION" {
  type    = bool
  default = true
}
variable "MAIN_SUBNET_CIDR" {
  type    = string
  default = "10.128.10.0/24"
}
variable "POD_RANGE_CIDR" {
  type    = string
  default = "192.168.0.0/19"
}
variable "SERVICE_RANGE_CIDR" {
  type    = string
  default = "10.0.0.0/16"
}

variable "ALLOWED_CONTAINER_REGISTRIES_IPS" {
  type    = string
  default = "0.0.0.0/0"
}

variable "GKE_MASTER_CIDR" {
  type    = string
  default = ""
}
variable "GKE_MASTER_SUBNET_NAME" {
  default = ""
}
variable "PVC_NAME" {
  type    = string
  default = "data-volume-claim"
}
variable "ALLOWED_INGRESS_CIDRS" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}
variable "ALLOWED_EGRESS_CIDRS" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}
variable "ALLOWED_CONTAINER_REGISTRIES" {
  type = list(string)
  default = [
    "ghcr.io",
    "gcr.io",
    "googleapis.com",
    "pkg.dev",
    "docker.io",
    "registry-1.docker.io",
    "auth.docker.io",
    "registry.docker.io",
    "index.docker.io",
    "dseasb33srnrn.cloudfront.net",
    "production.cloudflare.docker.com",
    "us.gcr.io",
    "eu.gcr.io",
    "asia.gcr.io",
    "quay.io",
    "public.ecr.aws",
    "azurecr.io",
    "registry.redhat.io",
    "docker.elastic.co",
    "registry.gitlab.com",
    "jfrog.io",
    "container-registry.oracle.com",
    "icr.io",
    "images.canonical.com",
    "nvcr.io",
    "mcr.microsoft.com"
  ]
}

variable "APP_DOMAIN" {
  type    = string
  default = "azuretest.bluebird.com"
}
variable "TLS_CERTIFICATE" {
  type    = string
  default = ""
}
variable "TLS_PRIVATE_KEY" {
  type    = string
  default = ""
}
variable "CREATE_K8S_ADMIN_SA" {
  type    = bool
  default = false
}
variable "DNS_FORWARDERS_ENABLED" {
  default = false
  type    = bool
}

variable "ENABLE_AKS_PUBLIC_ACCESS" {
  type    = bool
  default = false
}

variable "ALLOWED_AKS_PUBLIC_ACCESS_IP_RANGES" {
  type    = list(string)
  default = ["182.72.58.210/24"]
}

variable "Service_application_name" {
  type    = string
  default = "bluebird_spn"
}



variable "CREATE_INIT_NODE" {
  default = false
  type    = bool
}
variable "FLOW_SAMPLING" {
  default = 0.1
}
variable "USE_DEFAULT_COMPUTE_SA" {
  default = true
  type    = bool
}
variable "GKE_COMPUTE_SA_ROLE" {
  type    = string
  default = ""
}
variable "ENABLE_GKE_PUBLIC_ACCESS" {
  type    = bool
  default = false
}
variable "ENABLE_GKE_PRIVATE_ENDPOINT" {
  type    = bool
  default = true
}
variable "ALLOWED_GKE_PUBLIC_ACCESS_CIDRS" {
  type    = list(string)
  default = []
}
variable "PROXY_COMPUTE_SA_ROLE" {
  type    = string
  default = ""
}
variable "PROXY_IMAGE" {
  default = "debian-12-bookworm-v20240709"
}
variable "IAP_MEMBERS" {
  default = []
}
variable "IAP_CONDITION" {
  type    = string
  default = ""
}
variable "AWS_ENABLED" {
  default = false
}
variable "BOXYHQ_ENABLED" {
  default = true
}
variable "WORKOS_ENABLED" {
  default = false
}
variable "JWS_SERVICE" {
  default = "GCPKMS"
}
variable "CONNECTORS_OAUTH_SECRETS_TYPE" {
  default = "k8s"
}
variable "GCP_JWT_AUTH_KEY_VERSION" {
  default = "1"
}
variable "GCP_JWT_REFRESH_KEY_VERSION" {
  default = "1"
}
variable "SPRING_MAIL_SENDER" {
  type    = string
  default = ""
}
variable "SPRING_MAIL_USERNAME" {
  type    = string
  default = ""
}
variable "SPRING_MAIL_HOST" {
  type    = string
  default = ""
}
variable "SPRING_MAIL_PASSWORD" {
  type    = string
  default = ""
}
variable "SPRING_MAIL_PORT" {
  type    = number
  default = 587
}
variable "PUSHER_ENABLED" {
  type    = bool
  default = true
}
variable "MESSAGING_SERVER" {
  type    = string
  default = "CENTRIFUGO"
}
variable "bluebird_CERTIFICATE_NAME" {
  default = ""
}
variable "CENTRIFUGO_TOKEN_RSA_PUBLIC_KEY" {
  default = ""
}
variable "AUTHZ_API_IMAGE" {
  default = "busybox"
}
variable "DATA_PLANE_API_IMAGE" {
  default = "busybox"
}
variable "DFX_API_IMAGE" {
  default = "busybox"
}
variable "DFX_WORKER_IMAGE" {
  default = "busybox"
}
variable "CREATE_INGRESS" {
  default = true
}
variable "CREATE_K8S_RESOURCES" {
  default = true
}
variable "BLUI_IMAGE" {
  default = "busybox"
}
variable "DBT_BRANCH" {
  default = "dev"
}
variable "BOXY_CLIENT_ID" {
  default = ""
}
variable "AGGID_LICENSE_KEY" {
  default = ""
}
variable "CREATE_NETWORK" {
  default = true
}
variable "ENABLE_GCP_APIS" {
  default = true
}
variable "VPC_NAME" {
  default = ""
}
variable "SUBNET_NAME" {
  default = ""
}
variable "CREATE_GAR" {
  default = true
}
variable "PRIVATE_SERVICE_ACCESS_IP_RANGE_NAME" {
  default = ""
}
variable "CREATE_IAP_BINDING" {
  default = true
}
variable "CREATE_PROXY" {
  default = true
}
variable "BIND_PROJECT_IAM" {
  default = true
}
variable "POD_RANGE_NAME" {
  default = "pod-range"
}
variable "SERVICE_RANGE_NAME" {
  default = "services-range"
}
variable "USE_DEFAULT_SA_DEFAULT_POOL" {
  default = true
}
variable "GCP_SECRETS_REPLICATION_AUTO" {
  default = true
}
variable "SECURE_BOOT" {
  default = false
}
variable "GKE_NODE_IMAGE" {
  default = null
}
variable "KMS_SUFFIX" {
  default = "new"
}
variable "DBT_IMAGE_BIGQUERY" {
  default = ""
}
variable "SYSTEM_CONNECTOR_ENABLE_COLLECTIONS" {
  type    = bool
  default = false
}
variable "SYSTEM_CONNECTOR_SCHEDULE" {
  type    = string
  default = "*/10 * * * *"
}
variable "NODE_CONFIG_DEFAULT_GKE_NODE" {
  type    = bool
  default = false
}
variable "GMAIL_OAUTH_CLIENT_ID" {
  type    = string
  default = ""
}
variable "GMAIL_OAUTH_CLIENT_SECRET" {
  type    = string
  default = ""
}
variable "CONNECTOR_AUTHZ_API_URL" {
  type    = string
  default = ""
}

variable "SECRET_VALUE" {
  default = "bluebird"
}

variable "db_private_ip" {
  default = ""
}


variable "ALLOWED_CONTAINER_REGISTRIES_IPS1" {
  description = "List of IP ranges for allowed container registries"
  type        = list(string)
  default = [
    "IP_RANGE_1", # Replace with actual IP range for pkg.dev
    "IP_RANGE_2", # Replace with actual IP range for ghcr.io
    "IP_RANGE_3", # Replace with actual IP range for quay.io
    "IP_RANGE_4"  # Replace with actual IP range for docker.io
  ]
}

