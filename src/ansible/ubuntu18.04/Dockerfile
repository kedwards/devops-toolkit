FROM ubuntu:18.04

ARG ANSIBLE_VERSION_ARG="2.9.27"
ENV ANSIBLE_VERSION=${ANSIBLE_VERSION_ARG}

ARG YQ_VERSION_ARG="4.23.1"
ENV YQ_VERSION=${YQ_VERSION_ARG}

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

LABEL com.withreach.reach-devops.revision=$GIT_COMMIT \
  ca.kevinedwards.devops-toolkit.build-date=$BUILD_DATE \
  ca.kevinedwards.devops-toolkit.vcs-ref=$GIT_COMMIT \
  ca.kevinedwards.devops-toolkit.version=$VERSION \
  ca.kevinedwards.devops-toolkit.name="kevinedwards/devops-toolkit" \
  ca.kevinedwards.devops-toolkit.description="DevOps toolkit" \
  ca.kevinedwards.devops-toolkit.vcf-url="https://github.com/kevinedwards/devops-toolkit" \
  ca.kevinedwards.devops-toolkit.vendor="LivITy Ltd." \
  ca.kevinedwards.devops-toolkit.authors="Kevin Edwards <kedwards@kevinedwards.ca>" \
  ca.kevinedwards.devops-toolkit.docker.cmd="docker run -it --rm -v $(pwd):/ansible  -v ~/.ssh/id_rsa:/root/.ssh/id_rsa:ro kevinedwards/devops-toolkit:ubuntu_base_18.04"

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    curl \
    git \
    gnupg2 \
    jq \
    make \
    openssh-client \
    rsync \
    sshpass \
    wget \
    unzip && \
  rm -rf /var/lib/apt/lists/* && \
  DEBIAN_FRONTEND=noninteractive apt-get clean

RUN /usr/local/bin/python3 -m pip install --upgrade \
  awscli \
  cffi \
  pip \
  pywinrm && \
  pip install \
  ansible==${ANSIBLE_VERSION} \
  ansible-lint \
  ansible-runner \
  boto3 \
  botocore \
  github3.py \
  jmespath \
  mitogen && \
  rm -rf /root/.cache/pip

RUN wget "https://github.com/99designs/aws-vault/releases/download/v6.6.0/aws-vault-linux-amd64" -o /usr/local/bin/aws-vault && \
  curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb" && \
  dpkg -i session-manager-plugin.deb && \
  rm -f session-manager-plugin.deb && \
  curl -sS -L -o /usr/bin/kubectl \
		"https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && \
	chmod +x /usr/bin/kubectl && \
  wget "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64" -O /usr/bin/yq && \
  chmod +x /usr/bin/yq && \
  mkdir /ansible && \
  mkdir -p /etc/ansible && \
  echo 'localhost' > /etc/ansible/hosts

COPY ansible.cfg /etc/ansible/ansible.cfg

WORKDIR /ansible

CMD [ "ansible-playbook", "--version" ]