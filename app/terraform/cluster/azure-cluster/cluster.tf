resource "azurerm_resource_group" "group-1" {
  name     = var.cluster
  location = var.location
}

resource "azurerm_kubernetes_cluster" "cluster-1" {
  name                = "example-aks1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "node_pool1" {
  for_each = { for np in yamldecode(local.conf_file) : np.name => np }
  name       = each.value.name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.cluster_1.id
  vm_size               = each.value.vm_size
  os_type= each.value.os_type
  node_count            = each.value.node_count
  # Nodes autoscaling
  enable_auto_scaling = each.value.enable_auto_scaling


  node_taints = each.value.node_taints
  tags = {
    for_each = { for t in yamldecode(each.tags): t.tag => t }
    each.key = each.value
  }
}


output "client_certificate" {
  value = azurerm_kubernetes_cluster.example.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.example.kube_config_raw

  sensitive = true
}

locals {
  conf_file= file(var.node_pool_conf_file)
}

