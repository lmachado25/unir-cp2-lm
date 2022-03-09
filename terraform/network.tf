# Creación de red
resource "azurerm_virtual_network" "vnLmCp2" {
    name                = "netkubernetes"
    address_space       = ["192.168.0.0/16"]
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    tags = {
        environment = var.environment
    }
}

# Creación de subnet
resource "azurerm_subnet" "subNetLmCp2" {
    name                   = "subnetterraform"
    resource_group_name    = azurerm_resource_group.rg.name
    virtual_network_name   = azurerm_virtual_network.vnLmCp2.name
    address_prefixes       = ["192.168.1.0/24"]

}

# Create NIC - Master
resource "azurerm_network_interface" "nic-master" {
  name                = "vmnicmaster"  
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
    name                           = "ipvmmaster"
    subnet_id                      = azurerm_subnet.subNetLmCp2.id 
    private_ip_address_allocation  = "Static"
    private_ip_address             = "192.168.1.110"
    public_ip_address_id           = azurerm_public_ip.publicIpMasterLmCp2.id
  }

    tags = {
        environment = var.environment
    }

}

# IP pública - Master
resource "azurerm_public_ip" "publicIpMasterLmCp2" {
  name                = "vmpublicipmaster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"

    tags = {
        environment = var.environment
    }

}

# Create NIC - NFS
resource "azurerm_network_interface" "nic-nfs" {
  name                = "vmnicnfs"  
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
    name                           = "ipvmnfs"
    subnet_id                      = azurerm_subnet.subNetLmCp2.id 
    private_ip_address_allocation  = "Static"
    private_ip_address             = "192.168.1.115"
    public_ip_address_id           = azurerm_public_ip.publicIpNfsLmCp2.id
  }

    tags = {
        environment = var.environment
    }

}

# IP pública - NFS
resource "azurerm_public_ip" "publicIpNfsLmCp2" {
  name                = "vmpublicipnfs"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"

    tags = {
        environment = var.environment
    }

}


# Create NIC - Worker1
resource "azurerm_network_interface" "nic-worker-1" {
  name                = "vmnicworker1"  
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
    name                           = "ipvmworker1"
    subnet_id                      = azurerm_subnet.subNetLmCp2.id 
    private_ip_address_allocation  = "Static"
    private_ip_address             = "192.168.1.111"
    public_ip_address_id           = azurerm_public_ip.publicIpWorker1LmCp2.id
  }

    tags = {
        environment = var.environment
    }

}

# IP pública - Worker1
resource "azurerm_public_ip" "publicIpWorker1LmCp2" {
  name                = "vmpublicipworker1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"

    tags = {
        environment = var.environment
    }

}