resource "azurerm_storage_account" "sg"{
  name = "terraformstoretestsg"
  resource_group_name = "testtest1"
  location = "usgovvirginia"
  account_tier = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"
  tags = {
    ftag = "tf-test"
  }
  access_tier = "Hot"
  allow_nested_items_to_be_public = false
  cross_tenant_replication_enabled = false
  allowed_copy_scope = "AAD"
  shared_access_key_enabled = true
  infrastructure_encryption_enabled = true
  queue_encryption_key_type = "Service"
  table_encryption_key_type = "Service"
  is_hns_enabled = false
  nfsv3_enabled = false
  large_file_share_enabled = false
  min_tls_version = "TLS1_2"
  network_rules {
    bypass = ["AzureServices"]
    default_action = "Allow"
  }
  public_network_access_enabled = false
  enable_https_traffic_only = true
}

resource "azurerm_private_endpoint" "ape" {
    name = "terraformape"
    location = "usgovvirginia"
    resource_group_name = "testtest1"
    subnet_id = "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vnetName>/subnets/<subnetName>"
    private_service_connection {
        name = "terraformape"
        private_connection_resource_id = azurerm_storage_account.sg.id
        subresource_names = ["blob"]
        is_manual_connection = false
    }
    ip_configuration {
        name = "terraformape"
        private_ip_address = "<IPAddress>"
        subresource_name = "blob"
        member_name = "blob"
    }
    private_dns_zone_group {
        name = "terraformape_default"
        private_dns_zone_ids = ["/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.usgovcloudapi.net"]
    }
}
