FROM ubuntu:18.04

ENV PATH "$PATH:/usr/local/bin"

ARG PYTHON_VERSION_ARG="3.7"
ENV PYTHON_VERSION=${PYTHON_VERSION_ARG}

ARG ANSIBLE_VERSION_ARG="2.9.27"
ENV ANSIBLE_VERSION=${ANSIBLE_VERSION_ARG}

ARG YQ_VERSION_ARG="4.23.1"
ENV YQ_VERSION=${YQ_VERSION_ARG}

LABEL ca.kevinedwards.devops-toolkit.revision=$GIT_COMMIT \
  ca.kevinedwards.devops-toolkit.build-date=$BUILD_DATE \
  ca.kevinedwards.devops-toolkit.vcs-ref=$GIT_COMMIT \
  ca.kevinedwards.devops-toolkit.version=$VERSION \
  ca.kevinedwards.devops-toolkit.name="kevinedwards/devops-toolkit" \
  ca.kevinedwards.devops-toolkit.description="DevOps toolkit" \
  ca.kevinedwards.devops-toolkit.vcf-url="https://github.com/kevinedwards/devops-toolkit2" \
  ca.kevinedwards.devops-toolkit.vendor="LivITy Ltd." \
  ca.kevinedwards.devops-toolkit.authors="Kevin Edwards <kedwards@kevinedwards.ca>" \
  ca.kevinedwards.devops-toolkit.docker.cmd="docker run -it --rm -v $(pwd):/ansible  -v ~/.ssh/id_rsa:/root/.ssh/id_rsa:ro kevinedwards/devops-toolkit:ubuntu_base_18.04"

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
  apt-get install --no-install-recommends -y \
  curl git gnupg2 jq less libffi-dev libhdf5-dev libssl-dev make openssh-client patch rsync software-properties-common sshpass wget unzip zip && \
  add-apt-repository ppa:deadsnakes/ppa && \
  apt-get install -y python${PYTHON_VERSION} python${PYTHON_VERSION}-dev python3-pip && \
  rm -rf /var/lib/apt/lists/* && \
  apt-get clean

RUN python${PYTHON_VERSION} -m pip install --upgrade cffi pip && \
  pip install ansible==${ANSIBLE_VERSION} ansible-lint ansible-runner awscli boto3 botocore github3.py jmespath mitogen && \
  pip install --upgrade pywinrm && \
  rm -rf /root/.cache/pip

RUN ansible-galaxy collection install community.general && \
  curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb" && \
  dpkg -i session-manager-plugin.deb && \
  rm -f session-manager-plugin.deb && \
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
  install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
  curl "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64" -o /usr/local/bin/yq && \
  chmod +x /usr/local/bin/yq && \
  mkdir /ansible && \
  mkdir -p /etc/ansible && \
  echo 'localhost' > /etc/ansible/hosts

WORKDIR /ansible

CMD [ "ansible-playbook", "--version" ]