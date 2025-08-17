terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "devopscs5"
    storage_account_name = "cs5sc"
    container_name       = "cs5container"
    key                  = "terraform.tfstate"

  }  
}
provider "azurerm" {
  features {}
  subscription_id = "426b8104-3a89-42f0-a3f5-14b554b1b2bb"
  client_id       = "bf5e8e4f-3aea-40f9-bba6-0978ac70f104"
  tenant_id       = "09201aea-fd49-442b-9a0d-8de2389cefaf"
  client_secret   = "WtL8Q~2F1jhXJug7.42TcMEJInkXHZqhYZTfEdoR"
}
resource "azurerm_resource_group" "rg" {
  name     = var.rgname
  location = var.rglocation
}

resource "azurerm_container_registry" "acr" {
  name                = var.acrname
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Premium"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aksname
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.aksdnsname

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

resource "azurerm_role_assignment" "aksrole" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}
