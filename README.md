# DevOps Toolkit

A DevOps toolkit, with things that run other things..

Ansible and friends inside Docker for consistent running of ansible inside your local machine or CI/CD system.

## Current Versions

These are the latest versions running within the containers:

- Ansible: 2.12
- Mitogen: 0.3.0
- AWS Cli: aws-cli/1.22.77 Python/3.10.3 Linux/5.13.0-35-generic botocore/1.24.22
- Ansible Runner: 1.4.9
- AWS Systems Manager Plugin: Latest

## Mitogen Support

All installs include Mitogen mainly due to the performance improvements that Mitogen awards you. You can read more about it inside the [Mitogen for Ansible documentation](https://mitogen.readthedocs.io/en/stable/ansible.html).

### Configuring Mitogen

To leverage *Mitogen- to accelerate your playbook runs, add this to your ```ansible.cfg```:

Please investigate in your container the location of `ansible_mitogen` (it is different per container). You can do this via:

```bash
$(docker run --rm -it kevinedwards/devops-toolkit /bin/sh -c 'find / -type d | grep "ansible_mitogen/plugins" | sort | head -n 1')
```

and then configuring your own ansible.cfg like:


```bash
echo "
[defaults]
strategy_plugins = $(docker run --rm -it kevinedwards/devops-toolkit /bin/sh -c 'find / -type d | grep "ansible_mitogen/plugins" | sort | head -n 1')
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
docker run --rm -it kevinedwards/devops-toolkit
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

You can attach your AWS credentials using environment variables, but this is not the most secure method since your credentials are shown in the process list, You can also have a file containing the environment variables and then set the environment variables to use using the docker --env-file option. :

```bash
 docker run -it --rm \
  -v $(pwd):/ansible \
  -e AWS_ACCESS_KEY_ID=xxxxxx \
  -e AWS_SECRET_ACCESS_KEY=xxxxx \
  -e AWS_DEFAULT_REGION=us-east-1 \
  -v ~/.ssh/id_rsa:/root/id_rsa \
  kevinedwards/devops-toolkit:latest \
    ansible-playbook -i inventory/localhost.yml \
    project/playbook.yml \
    -K --ask-vault-pass --tags=<tags>
```

You can also attach your AWS Credentials file by mounting it in:

```bash
 docker run -it --rm \
  -v $(pwd):/ansible \
  -v ${HOME}/.aws/credentials:/root/.aws/credentials:ro \
  -v ~/.ssh/id_rsa:/root/id_rsa \
  kevinedwards/devops-toolkit \
    ansible-playbook -i inventory/localhost.yml \
    project/playbook.yml \
    -K --ask-vault-pass --tags=<tags> -e "aws_profile=<profile>"
```

## Executing playbooks for AWS environments

Production systems will usually contain encrypted variables files that contain credentials and sensitive information. The person running the production environment will need to have have access to the vault password.

Executing the playbooks will be as follows:

```
AWS_PROFILE=maison \
  docker run -it --rm \
  -v $(pwd):/ansible \
  -v $HOME/.aws/credentials:/root/.aws/credentials:ro \
  -v ~/.ssh/id_rsa:/root/id_rsa \
  kevinedwards/devops-toolkit:latest \
    ansible-playbook -i inventory/localhost.yml \
    project/playbook.yml \
    -K --ask-vault-pass --tags=<tags> -e "aws_profile=<profile>"
```

You can also store the vault password inside an external file and then reference it using the ansible-playbook --vault-password-file=<file location> option. If you do this, it's important to set the file permission to something more secure like 0600 so that only you can view the file.

One can also set the ANSIBLE_VAULT_PASSWORD_FILE environment variable to the location of the vault password file.

## Ansible runer

Ansible Runner is a tool that helps when interfacing with Ansible directly or as part of another system whether that be through a container image interface, as a standalone tool

Find out more [here](https://ansible-runner.readthedocs.io/en/stable/)

 ### Bash Alias

You can create aliases to ease your typing burden when using DevOps Toolkit:

```bash
  alias dt='docker run -it --rm \
  -v $(pwd):/ansible  \
  -v $HOME/.gitconfig:/root/.gitconfig:ro \
  -v $HOME/.git-credentials:/root/.git-credentials \
  -v $HOME/.aws/credentials:/root/.aws/credentials:ro \
  -v $HOME/.ssh/known_hosts:/root/.ssh/known_hosts:ro \
  -v $(readlink -f $SSH_AUTH_SOCK):/ssh-agent \
  -e SSH_AUTH_SOCK=/ssh-agent \
  -w /ansible \
  kevinedwards/devops-toolkit:latest'
```

