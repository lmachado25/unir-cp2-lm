# Caso práctico 2 - Automatización de despliegues en entornos Cloud
## Objetivos de la actividad
Se deberá desplegar un clúster de Kubernetes en Azure, que se compone de los siguientes elementos:

-----------------------------------------------------------------
| Role | Sistema Operativo | vCPUs | Memoria (GiB) | Disco Duro |
|------|-------------------|-------|---------------|------------|
| NFS  | CentOS 8          | 2     | 4             | 1 x 20 GiB (boot) |
| Master | CentOS 8        | 2     | 8             | 1 x 20 GiB (boot) |
| Worker | CentOS 8        | 2     | 4             | 1 x 20 GiB (boot) |
| Worker | CentOS 8        | 2     | 4             | 1 x 20 GiB (boot) |

## Arquitectura propuesta
![Image text](https://github.com/lmachado25/unir-cp2-lm/blob/master/img/arq_unir_cp2.png)

------------------------------------------------------------------------
| Role | Sistema Operativo | vCPUs | Memoria (GiB) | Disco Duro | Tipo |
|------|-------------------|-------|---------------|------------|------|
| NFS  | CentOS 8          | 2     | 4             | 1 x 20 GiB (boot) | Standard_A2_v2 |
| Master | CentOS 8        | 2     | 8             | 1 x 20 GiB (boot) | Standard_D2_v3 |
| Worker | CentOS 8        | 2     | 4             | 1 x 20 GiB (boot) | Standard_A2_v2 |

La aplicación propuesta es una webapp con una calculadora que ejecuta en nginx con volumen mapeado en el NFS.

![Image text](https://github.com/lmachado25/unir-cp2-lm/blob/master/img/calculadora.png)

## Instrucciones de despliegue


1.	Realizar el clonado del siguiente repositorio:

https://github.com/lmachado25/unir-cp2-lm.git

```console
lmachado@lmVSCode:~/unir-cp2-lm$ tree .
.
├── README.md
├── ansible
│   ├── deploy.sh
│   ├── groups_vars
│   │   ├── common.yaml
│   │   ├── initial.yaml
│   │   ├── k8s.yaml
│   │   ├── master.yaml
│   │   ├── nfs.yaml
│   │   ├── webapp.yaml
│   │   └── worker.yaml
│   ├── hosts
│   ├── node_master.yaml
│   ├── node_nfs.yaml
│   ├── node_workers.yaml
│   └── roles
│       ├── common
│       │   └── tasks
│       │       ├── 01.dnf_update.yaml
│       │       ├── 02.config_sync_time.yaml
│       │       ├── 03.config_SELinux.yaml
│       │       ├── 04.install_packages.yaml
│       │       ├── 05.config_firewall.yaml
│       │       └── main.yaml
│       ├── k8s
│       │   ├── files
│       │   │   └── cri-o.conf
│       │   └── tasks
│       │       ├── 01.config_etc_hosts.yaml
│       │       ├── 02.config_firewall.yaml
│       │       ├── 03.config_masquerade.yaml
│       │       ├── 04.config_swap.yaml
│       │       ├── 05.install_cri-o.yaml
│       │       ├── 06.config_repo_k8s.yaml
│       │       ├── 07.install_kubernetes.yaml
│       │       └── main.yaml
│       ├── master
│       │   └── tasks
│       │       ├── 01.config_firewall_k8s.yaml
│       │       ├── 02.config_firewall_workers.yaml
│       │       ├── 03.install_CNI.yaml
│       │       ├── 04.config_atrib_usr_root.yaml
│       │       ├── 05.install_SDN.yaml
│       │       ├── 06.install_ingress_controler.yaml
│       │       ├── 07.save_token.yaml
│       │       ├── 08.restart_master.yaml
│       │       └── main.yaml
│       ├── nfs
│       │   ├── files
│       │   │   └── index.html
│       │   └── tasks
│       │       ├── 01.install_packages_nfs.yaml
│       │       ├── 02.config_nfs_server.yaml
│       │       ├── 03.crear_carpeta_nfs.yaml
│       │       ├── 04.config_share_nfs.yaml
│       │       ├── 05.config_ports_firewall.yaml
│       │       ├── 06.install_app.yaml
│       │       └── main.yaml
│       ├── webapp
│       │   ├── files
│       │   │   ├── deployment.yaml
│       │   │   ├── nfs-pv.yaml
│       │   │   └── nfs-pvc.yaml
│       │   └── tasks
│       │       ├── 01.create_namespace.yaml
│       │       ├── 02.create_pv.yaml
│       │       ├── 03.create_pvc.yaml
│       │       ├── 04.deploy_webapp.yaml
│       │       └── main.yaml
│       └── worker
│           ├── files
│           │   └── token.conf
│           └── tasks
│               ├── 01.config_firewall_k8s.yaml
│               ├── 02.join_token.yaml
│               └── main.yaml
├── img
│   └── arq_unir_cp2.png
└── terraform
    ├── correccion-vars.tf
    ├── credentials.tf
    ├── main.tf
    ├── master.tf
    ├── network.tf
    ├── nfs.tf
    ├── security.tf
    ├── terraform.tfstate
    ├── terraform.tfstate.backup
    ├── vars.tf
    └── workers.tf

21 directories, 69 files
```

2.	Modificar el archivo correccion-vars.tf con los valores adecuados de las siguientes variables:

-	location -> Región de Azure donde desplegar la IaaC
-	storage_account -> Nombre de la cuenta de storage que debe ser única para todo Azure
-	public_key_path -> Ruta local en donde se encuentra la clave pública para establecer la conexión SSH
-	ssh_user -> Usuario utilizado para realizar la conexión SSH

3.	Agregar un archivo llamado credentials.tf en la carpeta terraform indicando los valores de la cuenta azure asociado al Service Principal previamente creado:

 ```yaml
  provider "azurerm" {
    features {}
    subscription_id = "<SUBSCRIPTION_ID>"
    client_id       = "<APP_ID>"         # se obtiene al crear el service principal
    client_secret   = "<CLIENT_SECRET>"  # se obtiene al crear el service principal
    tenant_id       = "<TENANT_ID>"      # se obtiene al crear el service principal
  }
```
4.	Ejecutar el comando $ terraform init

```console
lmachado@lmVSCode:~/unir-cp2-lm/terraform$ terraform init

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of hashicorp/azurerm from the dependency lock file
- Using previously-installed hashicorp/azurerm v2.46.1

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
lmachado@lmVSCode:~/unir-cp2-lm/terraform$ 
```
5.	Ejecutar el comando $ terraform apply

![Image text](https://github.com/lmachado25/unir-cp2-lm/blob/master/img/terraform_apply.png)

6.	Se mostrará un plan con la cantidad de elementos a desplegar, se deberá ingresar ‘yes’ para continuar.

7.	Al termino del despliegue se mostrará por pantalla las direcciones IP Públicas de los recursos desplegados:

![Image text](https://github.com/lmachado25/unir-cp2-lm/blob/master/img/ip_publicas.png)

8.	Reservar estas direcciones para ser utilizadas luego al necesitar conectarse o bien incorporarlas en el archivo /etc/hosts de la máquina desde la cual se realiza las conexiones:

![Image text](https://github.com/lmachado25/unir-cp2-lm/blob/master/img/archivo_hosts.png)

9.	Verificar la infraestructura desplegada en el portal de Azure:

![Image text](https://github.com/lmachado25/unir-cp2-lm/blob/master/img/portal_1.png)

![Image text](https://github.com/lmachado25/unir-cp2-lm/blob/master/img/portal_2.png)

10.	Ir a la carpeta ansible y adecuar el valor de la variable ansible_user en el inventario hosts:

![Image text](https://github.com/lmachado25/unir-cp2-lm/blob/master/img/inventario.png)

(utilizar el mismo usuario agregado en la variable ‘admin_ssh_key’ de Terraform)

11.	Dentro de la carpeta ansible ejecutar el Shell script deploy.sh

```console
~/unir-cp2-lm/ansible$ sh deploy.sh
```

* Nota: puede ocurrir cierta demora porque se realiza el “dnf update” en cada una de las máquinas a desplegar.

12.	Ingresar en el navegador http://master.lm.ar:31263/calc/index.html


## Detalle del script de instalación
```console
ansible-playbook -i hosts -l nfs node_nfs.yaml -v
ansible-playbook -i hosts -l master node_master.yaml -v
ansible-playbook -i hosts -l workers node_workers.yaml -v
```

1.	Primero despliega lo necesario en el nodo NFS tomando del inventario el label “workers”

Se ejecutan los roles: common y nfs

2.	Segundo despliega lo necesario en el nodo MASTER tomando del inventario el label “master”

Se ejecutan los roles: common, k8s, master y webapp

3.	Tercero despliega lo necesario en los nodos WORKERS tomando del inventario el label “workers”

Se ejecutan los roles: common, k8s y worker

## Detalle de los roles utilizados en el despliegue
```console

lmachado@lmVSCode:~/unir-cp2-lm/ansible/roles$ tree .
.
├── common
│   └── tasks
│       ├── 01.dnf_update.yaml
│       ├── 02.config_sync_time.yaml
│       ├── 03.config_SELinux.yaml
│       ├── 04.install_packages.yaml
│       ├── 05.config_firewall.yaml
│       └── main.yaml
├── k8s
│   ├── files
│   │   └── cri-o.conf
│   └── tasks
│       ├── 01.config_etc_hosts.yaml
│       ├── 02.config_firewall.yaml
│       ├── 03.config_masquerade.yaml
│       ├── 04.config_swap.yaml
│       ├── 05.install_cri-o.yaml
│       ├── 06.config_repo_k8s.yaml
│       ├── 07.install_kubernetes.yaml
│       └── main.yaml
├── master
│   └── tasks
│       ├── 01.config_firewall_k8s.yaml
│       ├── 02.config_firewall_workers.yaml
│       ├── 03.install_CNI.yaml
│       ├── 04.config_atrib_usr_root.yaml
│       ├── 05.install_SDN.yaml
│       ├── 06.install_ingress_controler.yaml
│       ├── 07.save_token.yaml
│       ├── 08.restart_master.yaml
│       └── main.yaml
├── nfs
│   ├── files
│   │   └── index.html
│   └── tasks
│       ├── 01.install_packages_nfs.yaml
│       ├── 02.config_nfs_server.yaml
│       ├── 03.crear_carpeta_nfs.yaml
│       ├── 04.config_share_nfs.yaml
│       ├── 05.config_ports_firewall.yaml
│       ├── 06.install_app.yaml
│       └── main.yaml
├── webapp
│   ├── files
│   │   ├── deployment.yaml
│   │   ├── nfs-pv.yaml
│   │   └── nfs-pvc.yaml
│   └── tasks
│       ├── 01.create_namespace.yaml
│       ├── 02.create_pv.yaml
│       ├── 03.create_pvc.yaml
│       ├── 04.deploy_webapp.yaml
│       └── main.yaml
└── worker
    ├── files
    │   └── token.conf
    └── tasks
        ├── 01.config_firewall_k8s.yaml
        ├── 02.join_token.yaml
        └── main.yaml

16 directories, 44 files
```


