FROM debian:10.4-slim

LABEL maintainer=inqfen@gmail.com

RUN apt update &&\
    apt install -y --no-install-recommends --no-install-suggests wget gnupg ca-certificates

RUN wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add - &&\
    echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.2 main" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list

RUN apt update &&\
    apt install -y --no-install-recommends --no-install-suggests \
    unzip \
    postgresql-client-11 \
    mongodb-org-shell \
    mongodb-org-tools \
    git \
    curl \
    python3 \
    python3-pip \
    sshpass \
    openssh-client

# Install dev deps
RUN apt install -y --no-install-recommends --no-install-suggests \
    postgresql-server-dev-11 \
    build-essential \
    python3-setuptools \
    python3-dev \
    gcc &&\

# Install terraform
    wget https://releases.hashicorp.com/terraform/0.12.24/terraform_1.0.1_linux_amd64.zip &&\
    unzip terraform_1.0.1_linux_amd64.zip &&\
    mv -f terraform /usr/bin/terraform &&\
    rm terraform_1.0.1_linux_amd64.zip &&\
# Install helm
    wget https://get.helm.sh/helm-v3.6.2-linux-amd64.tar.gz &&\
    tar -xzf helm-v3.6.2-linux-amd64.tar.gz &&\
    mv linux-amd64/helm /usr/local/bin/helm &&\
    rm helm-v3.6.2-linux-amd64.tar.gz &&\
# Install python packages
    pip3 install -U pip &&\
    pip3 install ansible==2.9.7 openshift pycrypto docker psycopg2 boto3 pymongo awscli mitogen==0.2.9 &&\
# Removing unnecessary packages
    apt remove -y postgresql-server-dev-11 build-essential gcc python3-setuptools python3-dev &&\
    apt autoremove -y &&\
    apt clean &&\
# Change key checking restrictions
    sed -i 's|#   StrictHostKeyChecking ask|StrictHostKeyChecking no|' /etc/ssh/ssh_config
