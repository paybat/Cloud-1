# Cloud-1: automated Inception deployment

This repository deploys WordPress, MariaDB, Redis, phpMyAdmin, and Nginx as separate Docker Compose services on Ubuntu 22.04 or a compatible host. Ansible configures the host, restricts inbound traffic, installs Docker, and starts the stack. WordPress and MariaDB data live in persistent directories under `/var/lib/cloud-1`.

## Requirements

- Ansible on the control machine
- SSH access as `root` to each target host (the assignment requires root login)
- Ubuntu 22.04 LTS or a compatible Ubuntu host with SSH and Python 3
- DNS for the configured domain pointing to the target, when using a public host

Install the required Ansible collections:

```sh
ansible-galaxy collection install -r requirements.yml
```

The database and WordPress credentials are stored in `secrets/vault.yml`. Supply the vault password using Ansible Vault's normal password-file or prompt options. Do not commit the vault password.

## Configure targets

Edit `inventory/hosts.ini` with one or more target hosts. Example:

```ini
[cloud]
web1 ansible_host=203.0.113.10 ansible_user=root ansible_python_interpreter=/usr/bin/python3
web2 ansible_host=203.0.113.11 ansible_user=root ansible_python_interpreter=/usr/bin/python3
```

Set `cloud1_domain_name` in `inventory/group_vars/all.yml` to the DNS name for the deployment. Set `cloud1_enable_firewall: true` to allow only SSH (22), HTTP (80), and HTTPS (443) inbound through UFW. Configure the cloud provider's network firewall/security group to allow the same ports; host firewall rules cannot override provider-level network policy.

The included inventory currently describes the local Vagrant development VM. Replace it with the remote inventory above for a cloud deployment. Ansible deploys to all hosts in the `[cloud]` group in parallel by default.

## Deploy

```sh
ansible-playbook playbooks/deploy.yml --ask-vault-pass
```

For a vault password file, use `--vault-password-file /secure/path/to/vault-pass`. The deployment is designed to be repeatable and will preserve the WordPress and database directories across restarts and Compose updates.

The Nginx container redirects HTTP to HTTPS and generates a domain-specific self-signed certificate if no certificate is supplied. Browsers will warn for that certificate. For a trusted certificate, set both `cloud1_tls_cert_src` and `cloud1_tls_key_src` in `inventory/group_vars/all.yml` to paths on the Ansible control machine; the playbook copies them into the persistent TLS directory. phpMyAdmin has no public host port and is exposed only through Nginx over HTTPS.

Run `ansible-playbook playbooks/configure.yml` to configure hosts without deploying the application. Run `ansible-playbook playbooks/verify.yml` after deployment to check Compose service status.

## Services and exposure

Only Nginx publishes host ports 80 and 443. MariaDB, WordPress/PHP-FPM, Redis, and phpMyAdmin communicate over the private Compose network. phpMyAdmin is reachable through the HTTPS path `/phpmyadmin/`. SSH is provided by the host, not Compose. UFW defaults to deny incoming traffic and allows ports 22, 80, and 443.

## Local development

`Vagrantfile` and `inventory/hosts.ini` provide a local Ubuntu Jammy VM. After starting it with Vagrant, run the deploy command above. Set up a local DNS/hosts entry for the configured domain if testing the site by name.
