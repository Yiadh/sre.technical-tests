# Pre-requisites

Before running the playbook, ensure you have the following:

- Ansible installed on your local machine.
- A working inventory file that specifies your target hosts.
- Docker and NGINX roles installed via Ansible Galaxy.

### Install NGINX role
```bash
ansible-galaxy install nginxinc.nginx
```

### Install Docker role
```bash
ansible-galaxy install geerlingguy.docker
```

# Running the Playbook

To run the playbook, use the following command:

```bash
ansible-playbook -i inventory_file main.yaml --inventory <YOUR INVENTORY FILE PATH> --vault-password-file encryption_key
```
