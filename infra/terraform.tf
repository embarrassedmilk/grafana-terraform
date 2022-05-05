terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "terraform-state"
    storage_account_name = "terraformvmatveev"
    container_name       = "terraform-tfstate"
    key                  = "grafana-infra.tfstate"
  }
}

provider "azurerm" {
  features {}
}

provider "random" {
}

