FROM ubuntu:22.04

ARG ANSIBLE_VERSION_ARG "2.12.2"
ENV ANSIBLE_VERSION ${ANSIBLE_VERSION_ARG}

# Labels.
LABEL com.withreach.reach-devops.revision=$GIT_COMMIT \
  ca.kevinedwards.ansible.build-date=$BUILD_DATE \
  ca.kevinedwards.ansible.vcs-ref=$SOURCE \
  ca.kevinedwards.ansible.version=$VERSION \
  ca.kevinedwards.ansible.name="kevinedwards/ansible" \
  ca.kevinedwards.ansible.description="Dockerized Ansible + Mitogen + AWS Session Manager" \
  ca.kevinedwards.ansible.vcf-url="https://github.com/kevinedwards/ansible" \
  ca.kevinedwards.ansible.vendor="LivITy Ltd." \
  ca.kevinedwards.ansible.authors="Kevin Edwards <kedwards@kevinedwards.ca>" \
  ca.kevinedwards.ansible.docker.cmd="docker run -it --rm -e 'AWS_PROFILE=profile' -v \$(pwd):/ansible ~/.aws/credentials:/root/.aws/credentials ~/.ssh/_id_rsa.pem:/root/id_rsa ansible"

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
  apt-get install --no-install-recommends -y unzip rsync sudo curl gnupg2 python3-pip sshpass git openssh-client && \
  rm -rf /var/lib/apt/lists/* && \
  apt-get clean

RUN python3 -m pip install --upgrade pip cffi && \
  pip install boto3 botocore ansible-core==2.12.2 ansible && \
  pip install mitogen ansible-lint jmespath ansible-runner && \
  pip install --upgrade pywinrm && \
  rm -rf /root/.cache/pip && \
  curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb" && \
  dpkg -i session-manager-plugin.deb && \
  rm -f session-manager-plugin.deb

RUN mkdir /ansible && \
  mkdir -p /etc/ansible && \
  echo 'localhost' > /etc/ansible/hosts

WORKDIR /ansible

CMD [ "ansible-playbook", "--version" ]