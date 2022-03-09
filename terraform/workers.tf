# Creamos una máquina virtual - Worker

resource "azurerm_linux_virtual_machine" "vmWorker1" {
    name                = "azure-vm-worker-1"
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    size                = var.vm_size_worker
    admin_username      = var.ssh_user
    network_interface_ids = [ azurerm_network_interface.nic-worker-1.id ]
    disable_password_authentication = true

    admin_ssh_key {
        username   = var.ssh_user
        public_key = file(var.public_key_path)
    }

    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    plan {
        name      = "centos-8-stream-free"
        product   = "centos-8-stream-free"
        publisher = "cognosys"
    }

    source_image_reference {
        publisher = "cognosys"
        offer     = "centos-8-stream-free"
        sku       = "centos-8-stream-free"
        version   = "1.2019.0810"
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.stAccountLmCp2.primary_blob_endpoint
    }

    tags = {
        environment = var.environment
    }

}

resource "azurerm_linux_virtual_machine" "vmWorker2" {
    name                = "azure-vm-worker-2"
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    size                = var.vm_size_worker
    admin_username      = var.ssh_user
    network_interface_ids = [ azurerm_network_interface.nic-worker-2.id ]
    disable_password_authentication = true

    admin_ssh_key {
        username   = var.ssh_user
        public_key = file(var.public_key_path)
    }

    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    plan {
        name      = "centos-8-stream-free"
        product   = "centos-8-stream-free"
        publisher = "cognosys"
    }

    source_image_reference {
        publisher = "cognosys"
        offer     = "centos-8-stream-free"
        sku       = "centos-8-stream-free"
        version   = "1.2019.0810"
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.stAccountLmCp2.primary_blob_endpoint
    }

    tags = {
        environment = var.environment
    }

}