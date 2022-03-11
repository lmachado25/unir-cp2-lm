# Despliegue de la VM master
#ansible-playbook -i hosts -l master node_master.yaml -v
ansible-playbook -i hosts -l nfs node_nfs.yaml -v