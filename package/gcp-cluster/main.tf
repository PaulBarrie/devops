locals {
  default_node_pool = {
    name               = "default-node-pool"
    machine_type       = "e2-medium"
    node_locations     = "europe-west1-b,europe-west1-c"
    min_count          = 1
    max_count          = 10
    local_ssd_count    = 0
    disk_size_gb       = 10
    disk_type          = "pd-standard"
    image_type         = "COS"
    auto_repair        = true
    auto_upgrade       = true
    service_account    = "project-service-account@${var.project_id}.iam.gserviceaccount.com"
    preemptible        = false
    initial_node_count = 5
  }
#   for_each = {
#     for key, value in var.node_pools :
#     key => concat(node_pools_formated, merge(value, default_node_pool))
#   }
}

locals {
    node_pools_formated = [ merge(var.node_pool1, local.default_node_pool)]
}


module "gcp-network" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 2.5"
  project_id   = var.project_id
  network_name = "${var.network}-${var.env_name}"
  subnets = [
    {
      subnet_name   = "${var.subnetwork}-${var.env_name}"
      subnet_ip     = "10.10.0.0/16"
      subnet_region = var.region
    },
  ]
  secondary_ranges = {
    "${var.subnetwork}-${var.env_name}" = [
      {
        range_name    = var.ip_range_pods_name
        ip_cidr_range = "10.20.0.0/16"
      },
      {
        range_name    = var.ip_range_services_name
        ip_cidr_range = "10.30.0.0/16"
      },
    ]
  }
}



module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = var.project_id
  name                       = var.cluster_config.cluster
  region                     = var.cluster_config.region
  zones                      = var.cluster_config.zones
  network                    = var.cluster_config.network
  subnetwork                 = var.cluster_config.subnetwork
  ip_range_pods              = var.cluster_config.ip_range_pods
  ip_range_services          = var.cluster_config.ip_range_services
  http_load_balancing        = var.cluster_config.http_load_balancing
  horizontal_pod_autoscaling = var.cluster_config.horizontal_pod_autoscaling
  network_policy             = var.cluster_config.network_policy

  /* for_each   = { for pool in var.node_pools : pool.service_account => "project-service-account@${var.project_id}.iam.gserviceaccount.com" } */
  node_pools         = local.node_pools_formated

  node_pools_oauth_scopes = {
    all = []
    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}