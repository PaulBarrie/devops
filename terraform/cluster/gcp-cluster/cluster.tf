resource "google_container_cluster" "gcp-europe-cluster" {
  name        = var.cluster
  project     = var.project
  description = "Demo GKE Cluster"
  location    = var.location
  node_locations = ["${var.location}-b", "${var.location}-c"]

  remove_default_node_pool = true
  initial_node_count       = var.initial_node_count

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

locals {
  conf_file= file(var.node_pool_conf_file)
}

resource "google_container_node_pool" "node_pool storage" {
  for_each = { for np in yamldecode(local.conf_file) : np.name => np }
  name       = each.value.name
  project    = var.project
  cluster    = google_container_cluster.default.name
  node_count = try(each.value.node_count, 0)
  autoscaling {
    min_node_count= try(each.value.autoscaling.min_node, each.value.node_count)
    max_node_count= try(each.value.autoscaling.max_node, each.value.node_count)
  }
  node_config {
    preemptible  = each.value.preemptible
    machine_type = each.value.machine_type

    guest_accelerator {
      type  = each.value.accelerator.type
      count = "${each.value.accelerator.type == "" ? 0 : each.value.accelerator.count}"
    }

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
