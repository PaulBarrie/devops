
variable "gcp_auth_file" {
  type=string
  description = "JSON files with gcloud credentials"
  default = "../config/key.json"
}
variable "project_id" {
  type = string
}

variable "env_name" {
  type = string
  description = "The environment for the GKE cluster"
  default     = "prod"
}

variable "region" {
  description = "The region to host the cluster in"
  default     = "europe-west1"
}

variable "network" {
  description = "The VPC network created to host the cluster in"
  default     = "gke-network"
}

variable "subnetwork" {
  description = "The subnetwork created to host the cluster in"
  default     = "gke-subnet"
}

variable "ip_range_pods_name" {
  description = "The secondary ip range to use for pods"
  default     = "ip-range-pods"
}

variable "ip_range_services_name" {
  description = "The secondary ip range to use for services"
  default     = "ip-range-services"
}

variable "cluster_config" {
  type = object({
    cluster = string
    project_id                 = string
    region                     = string
    zones                      = list(string)
    network                    = string
    subnetwork                 = string
    ip_range_pods              = string
    ip_range_services          = string
    http_load_balancing        = bool
    horizontal_pod_autoscaling = bool
    network_policy             = bool
  })
  description = "Define the cluster specifications"
  default = {
    cluster= "cluster-terra"
    project_id                 = "winged-ratio-312113"
    region                     = "europe-west1"
    zones                      = ["europe-west1-b", "europe-west1-c", "europe-west1-d"]
    network                    = "vpc-01"
    subnetwork                 = "europe-west1-b"
    ip_range_pods              = "europe-west1-b-gke-01-pods"
    ip_range_services          = "europe-west1-b-gke-01-services"
    http_load_balancing        = false
    horizontal_pod_autoscaling = true
    network_policy             = false
  }
}


variable "node_pool1" {
  type = object({
    name               = string
    machine_type       = string
    node_locations     = string
    min_count          = number
    max_count          = number
    local_ssd_count    = number
    disk_size_gb       = number
    disk_type          = string
    image_type         = string
    auto_repair        = bool
    auto_upgrade       = bool
    preemptible        = bool
    initial_node_count = number
    accelerator_type   = string
  })
  default = {
    name               = "pool-02"
    machine_type       = "n1-standard-2"
    min_count          = 1
    max_count          = 2
    local_ssd_count    = 0
    disk_size_gb       = 1
    disk_type          = "pd-standard"
    accelerator_count  = 1
    initial_node_count = 1
    accelerator_type   = ""
    node_locations     = "europe-west1-b"
    preemptible        = false
    image_type         = "COS"
    auto_upgrade       = true
    auto_repair        = true
  }
}


variable "cluster_autoscaling" {
  type = object({
    enabled             = bool
    autoscaling_profile = string
    min_cpu_cores       = number
    max_cpu_cores       = number
    min_memory_gb       = number
    max_memory_gb       = number
  })
  default = {
    enabled             = false
    autoscaling_profile = "BALANCED"
    max_cpu_cores       = 1
    min_cpu_cores       = 0
    max_memory_gb       = 1
    min_memory_gb       = 0
  }
  description = "Cluster autoscaling configuration. See [more details](https://cloud.google.com/kubernetes-engine/docs/reference/rest/v1beta1/projects.locations.clusters#clusterautoscaling)"
}


/* variable "cluster_config" {
    type = "map"
    default = {
        identifiers= jsondecode(file("${path.module}/../config/key.json"))
        test = yamldecode(file("${path.module}/../config/test.yml"))
    }
} */

/* 
variable "node_pools" {
    type = list(object)
    default = lookup(vars.configs, terraform.workspace, "")
} */