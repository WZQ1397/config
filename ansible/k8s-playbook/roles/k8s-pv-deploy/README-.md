### HOW TO START
1. CHANGE YOUR site.yml for roles to play
# vi site.yml
- name: apply common configuration to all nodes
  hosts: 127.0.0.1
  remote_user: root
  roles:
    - k8s-jar-deploy

2. PLAY THE PLAYBOOK AS FOLLOW
   Option -e which means import particular vars for project

# ansible-playbook site.yml -e "COUNT:5"
