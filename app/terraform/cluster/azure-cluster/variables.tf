
# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables are expected to be passed in by the operator.
# ---------------------------------------------------------------------------------------------------------------------



variable "project" {
  description = "The project ID where all resources will be launched."
  type        = string
}

variable "ressource_group_name" {
  description = "The name of the Azure group rsrces"
  type        = string
  default = "default-group"
}

variable "cluster" {
  description= "Name of the cluster"
  default = "default-cluster"
}
variable "location" {
  description = "The location (region or zone) of the GKE cluster."
  type        = string
  default = "West Europe"
}

# variable "region" {
#   description = "The region for the network. If the cluster is regional, this must be the same region. Otherwise, it should be the region of the zone."
#   type        = string
# }

variable "node_pool_conf_file" {
  description = "The yaml file containing node pool confs"
  type = string
  default = "../config/azure-node-pools.yaml"
}

variable "initial_node_count" {
  default = 1
}

variable "machine_type" {
  default = "n1-standard-1"
}

variable "sa_users" {
  type = list(string)
  default = []  
}
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_name" {
  description = "The name of the Kubernetes cluster."
  type        = string
  default     = "example-private-cluster"
}

variable "cluster_service_account_name" {
  description = "The name of the custom service account used for the GKE cluster. This parameter is limited to a maximum of 28 characters."
  type        = string
  default     = "example-private-cluster-sa"
}

variable "cluster_service_account_description" {
  description = "A description of the custom service account used for the GKE cluster."
  type        = string
  default     = "Example GKE Cluster Service Account managed by Terraform"
}
