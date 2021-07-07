# Retrieve an access token as the Terraform runner
provider "google" {
  project     = var.project_id
  # credentials = file(var.gcp_auth_file)
  region      = var.cluster_config.region
  zone = var.cluster_config.zones[0]
}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

provider "google-beta" {
  region  = var.region
}