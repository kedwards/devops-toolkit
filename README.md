# Docker + Ansible + Mitogen + Ansible Runner + AWS SSM Manager

Ansible and friends inside Docker for consistent running of ansible inside your local machine or CI/CD system.

## Current Versions

These are the latest versions running within the containers:

- Ansible: 2.12
- Mitogen: 0.3.0
- Ansible Runner: 1.4.9
- AWS Systems Manager Plugin: Latest

## Mitogen Support

All installs include Mitogen mainly due to the performance improvements that Mitogen awards you. You can read more about it inside the [Mitogen for Ansible documentation](https://mitogen.readthedocs.io/en/stable/ansible.html).

### Configuring Mitogen

To leverage *Mitogen- to accelerate your playbook runs, add this to your ```ansible.cfg```:

Please investigate in your container the location of `ansible_mitogen` (it is different per container). You can do this via:

```bash
$(docker run --rm -it ansible:v1 /bin/sh -c 'find / -type d | grep "ansible_mitogen/plugins" | sort | head -n 1')
```

and then configuring your own ansible.cfg like:


```bash
echo "
[defaults]
strategy_plugins = $(docker run --rm -it ansible:v1 /bin/sh -c 'find / -type d | grep "ansible_mitogen/plugins" | sort | head -n 1')
strategy = mitogen_linear
"
```

Your ansible.cfg should have a stanza as shown below.

```ini
[defaults]
strategy_plugins = /usr/local/lib/python3.10/dist-packages/ansible_mitogen/plugins
strategy = mitogen_linear
```

## Usage

**You will likely need to mount required directories into your container**

### Simple

```bash
docker run --rm -it ansible:v1
```

no parameters, will run ansible-playbook --version

```shell
ansible-playbook [core 2.12.2]
  config file = None
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/local/lib/python3.10/dist-packages/ansible
  ansible collection location = /root/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/local/bin/ansible-playbook
  python version = 3.10.2+ (main, Mar 14 2022, 05:18:40) [GCC 11.2.0]
  jinja version = 3.0.3
  libyaml = True
```


### Mount local file / directory, ssh key, and AWS profile

```bash
 docker run -it --rm \
  -v $(pwd):/ansible \
  ~/.aws:/root/.aws \
  -v ~/.ssh/id_rsa:/root/id_rsa \
  ansible:v1 \
    ansible-playbook project/playbook.yml \
      -e 'AWS_PROFILE=profile' \
      -K \
      --ask-vault-pass \
      --tags=req
```

## Ansible runer

Ansible Runner is a tool that helps when interfacing with Ansible directly or as part of another system whether that be through a container image interface, as a standalone tool

Find out more [here](https://ansible-runner.readthedocs.io/en/stable/)

```bash
 docker run -it --rm \
  -v $(pwd):/ansible \
  ~/.aws:/root/.aws \
  -v ~/.ssh/id_rsa:/root/id_rsa \
  ansible:v1 \
    ansible-runner run /ansible -p playbook.yml
 ```

 ### Bash Alias

You can create aliases to ease your typing burden when using:

```bash
alias docker-ansible-cli='docker run --rm -it -v $(pwd):/ansible -v ~/.ssh/id_rsa:/root/.ssh/id_rsa --workdir=/ansible ansible:v1 bash'

alias docker-ansible-cmd='docker run --rm -it -v $(pwd):/ansible -v ~/.ssh/id_rsa:/root/.ssh/id_rsa --workdir=/ansible ansible:v1 '
```
