# Security group
resource "azurerm_network_security_group" "securityGroupLmCp2" {
    name                = "sshtraffic"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "PORTS"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "25000-65000"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = var.environment
    }
}

# Vinculamos el security group al interface de red - Master
resource "azurerm_network_interface_security_group_association" "securityGroupAsocMasterLmCp2" {
    network_interface_id      = azurerm_network_interface.nic-master.id
    network_security_group_id = azurerm_network_security_group.securityGroupLmCp2.id

}

# Vinculamos el security group al interface de red - Nfs
resource "azurerm_network_interface_security_group_association" "securityGroupAsocNfsLmCp2" {
    network_interface_id      = azurerm_network_interface.nic-nfs.id
    network_security_group_id = azurerm_network_security_group.securityGroupLmCp2.id

}

# Vinculamos el security group al interface de red - Worker1
resource "azurerm_network_interface_security_group_association" "securityGroupAsocWorker1LmCp2" {
    network_interface_id      = azurerm_network_interface.nic-worker-1.id
    network_security_group_id = azurerm_network_security_group.securityGroupLmCp2.id

}