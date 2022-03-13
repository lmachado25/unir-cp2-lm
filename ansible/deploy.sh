ansible-playbook -i initial -l initial initial.yaml -v
ansible-playbook -i hosts -l nfs node_nfs.yaml -v
ansible-playbook -i hosts -l master node_master.yaml -v
ansible-playbook -i hosts -l workers node_workers.yaml -v