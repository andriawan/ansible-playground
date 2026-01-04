docker save -o images/ubuntu-24.02.tar docker-ubuntu-ssh:latest
docker save -o images/ansible-2.20.0.tar alpine/ansible:2.20.0
docker load -i images/ubuntu-24.02.tar
docker load -i images/ansible-2.20.0.tar

#ansible
docker compose -f ansible/compose.yml run --rm ansible ansible-playbook -i inventory/hosts playbook.yml --tags webserver
docker compose -f ansible/compose.yml run --rm ansible
docker compose -f ansible/compose.yml run --rm ansible ansible-galaxy role init setup_frontend_webserver
docker compose -f docker/compose.yml up -d
docker compose -f docker/compose.yml build
docker compose -f docker/compose.yml down

ssh -i ansible/roles/setup_ssh_root_keyonly/files/sample-key root@172.20.0.3
ssh -i ansible/roles/setup_ssh_root_keyonly/files/sample-key deployer@172.20.0.2
ssh-keygen -f '/home/andriawan2014/.ssh/known_hosts' -R '172.20.0.2'
ssh-keygen -f '/home/andriawan2014/.ssh/known_hosts' -R '172.20.0.3'
sudo chown -R andriawan2014:andriawan2014 ansible/
cat /etc/sudoers.d/deployer

git commit --amend --no-edit
git push -f origin HEAD