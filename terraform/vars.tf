variable "vm_size_master" {
  type = string
  description = "Tamaño de la máquina virtual Master"
  default = "Standard_D2_v3" # 8 GB, 2 CPU 
}

variable "vm_size_nfs" {
  type = string
  description = "Tamaño de la máquina virtual NFS"
  default = "Standard_A2_v2" # 4 GB, 2 CPU 
}

variable "vm_size_worker" {
  type = string
  description = "Tamaño de la máquina virtual Worker"
  default = "Standard_A2_v2" # 4 GB, 2 CPU 
}

variable "environment" {
  type = string
  description = "Nombre de la etiqueta environment"
  default = "UNIR_LM_CP2" 
}