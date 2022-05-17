FROM debian:11.0-slim

LABEL maintainer=inqfen@gmail.com

RUN apt update &&\
    apt install -y --no-install-recommends --no-install-suggests wget gnupg ca-certificates

RUN wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add - &&\
    echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.2 main" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list

RUN apt update &&\
    apt install -y --no-install-recommends --no-install-suggests \
    unzip \
    postgresql-client-13 \
    mongodb-org-shell \
    mongodb-org-tools \
    git \
    curl \
    python3 \
    python3-pip \
    sshpass \
    openssh-client \
    awscli &&\

# Install dev deps
    apt install -y --no-install-recommends --no-install-suggests \
    postgresql-server-dev-13 \
    build-essential \
    python3-setuptools \
    python3-dev \
    gcc &&\

# Docker client installation
    apt install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release &&\
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg &&\
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null &&\
    apt update &&\
    apt install -y --no-install-recommends docker-ce-cli &&\

# Install terraform
    wget https://releases.hashicorp.com/terraform/1.0.5/terraform_1.0.5_linux_amd64.zip &&\
    unzip terraform_1.0.5_linux_amd64.zip &&\
    mv -f terraform /usr/bin/terraform &&\
    rm terraform_1.0.5_linux_amd64.zip &&\
# Install helm
    wget https://get.helm.sh/helm-v3.6.2-linux-amd64.tar.gz &&\
    tar -xzf helm-v3.6.2-linux-amd64.tar.gz &&\
    mv linux-amd64/helm /usr/local/bin/helm &&\
    rm helm-v3.6.2-linux-amd64.tar.gz &&\
# Install python packages
    pip3 install -U pip &&\
    pip3 install ansible-base=2.10.17 openshift pycrypto docker psycopg2 boto3 pymongo mitogen==0.3.2 &&\
# Removing unnecessary packages
    apt remove -y postgresql-server-dev-13 build-essential gnupg gcc python3-pip python3-setuptools python3-dev apt-transport-https unzip lsb-release &&\
    apt autoremove -y &&\
    apt clean &&\
# Change key checking restrictions
    sed -i 's|#   StrictHostKeyChecking ask|StrictHostKeyChecking no|' /etc/ssh/ssh_config
