project_id = "winged-ratio-312113 "


cluster_config = {
  cluster = "cluster-terraform"
  project_id = "winged-ratio-312113"
  region = "europe-west1"
  zones =  ["europe-west1-b", "europe-west1-c", "europe-west1-d"]
  network = "vpc-01"
  subnetwork = "europe-west1-b"
  ip_range_pods = "europe-west1-b-gke-01-pods"
  ip_range_services = "europe-west1-b-gke-01-services"
  http_load_balancing = false
  horizontal_pod_autoscaling = true
  network_policy = false
}

node_pool1 = {
  name               = "pool-01"
  machine_type       = "n1-standard-2"
  disk_type          = "pd-standard"
  machine_type       = "n1-standard-2"
  image_type         = "COS"
  initial_node_count = 1
  min_count          = 1
  max_count          = 2
  auto_upgrade       = true
  auto_repair        = true
  local_ssd_count    = true
  accelerator_type   = ""
  disk_size_gb       = 1
  node_locations     = "europe-west1-b"
  preemptible        = false
  local_ssd_count= 1
}
# "pool-02" = {
#     name              = "pool-02"
#     machine_type      = "n1-standard-2"
#     min_count         = 1
#     max_count         = 2
#     local_ssd_count   = 0
#     disk_size_gb      = 1
#     disk_type         = "pd-standard"
#     accelerator_count = 1
#     accelerator_type  = "nvidia-tesla-p4"
#     image_type        = "COS"
#     auto_upgrade    = true
#     auto_repair       = true
#   },
# "pool-03" = { 
#     name              = "pool-03"
#     machine_type      = "n1-standard-2"
#     min_count         = 1
#     max_count         = 2
#     local_ssd_count   = 0
#     disk_size_gb      = 1
#     disk_type         = "pd-standard"
#     accelerator_count = 1
#     accelerator_type  = "nvidia-tesla-p4" 
#     image_type        = "COS"
#     auto_upgrade    = true
#     auto_repair       = true
#   },
# ]