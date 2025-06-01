# devops-devcontainer/Dockerfile

FROM ubuntu:latest

# Set the user under which the container will operate
ARG CONTAINER_USER=devops
ARG USER_UID=2000 # Keep this (or whatever unique ID you chose)
ARG USER_GID=2000 # Keep this (or whatever unique ID you chose)

# Update package lists and install basic utilities
RUN apt-get update && apt-get install -y \
    sudo \
    curl \
    wget \
    git \
    unzip \
    zip \
    zsh \
    gnupg \
    lsb-release \
    nano \
    vim \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create user and group
RUN groupadd --gid $USER_GID $CONTAINER_USER \
    && useradd --uid $USER_UID --gid $USER_GID -m $CONTAINER_USER \
    && echo $CONTAINER_USER ALL=\(ALL\) NOPASSWD:ALL > /etc/sudoers.d/$CONTAINER_USER \
    && chmod 0440 /etc/sudoers.d/$CONTAINER_USER

# IMPORTANT: Switch back to root for installing system-wide tools
USER root

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" \
    && unzip /tmp/awscliv2.zip -d /tmp \
    && /tmp/aws/install \
    && rm /tmp/awscliv2.zip \
    && rm -rf /tmp/aws

# Install Terraform
RUN wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list \
    && apt update && apt install -y terraform

# Install kubectl (for Kubernetes)
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && rm kubectl

# Install Helm (for Kubernetes)
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install Docker CLI (for interacting with the Docker Daemon inside the container)
RUN install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && chmod a+r /etc/apt/keyrings/docker.gpg \
    && echo \
    "deb [arch=\"$(dpkg --print-architecture)\" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    \"$(. /etc/os-release && echo \"$VERSION_CODENAME\")\" stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update && apt-get install -y docker-ce-cli

# Install jq (JSON processor)
RUN apt-get update && apt-get install -y jq && rm -rf /var/lib/apt/lists/*

# Install yq (YAML processor)
RUN wget https://github.com/mikefarah/yq/releases/download/v4.44.1/yq_linux_amd64 -O /usr/local/bin/yq \
    && chmod +x /usr/local/bin/yq

# Install Python, pip, and python3-venv (for virtual environments)
RUN apt-get update && apt-get install -y python3 python3-pip python3-venv && rm -rf /var/lib/apt/lists/*

# Install Bash-completion for some tools
RUN apt-get update && apt-get install -y bash-completion && rm -rf /var/lib/apt/lists/*

# IMPORTANT: Switch back to the devops user for user-specific settings and default user
USER $CONTAINER_USER

# Set the default working directory for the devops user
WORKDIR /home/$CONTAINER_USER

# Create and activate a virtual environment for the devops user
# and install Python packages into it
RUN python3 -m venv ~/.venv \
    && echo 'source ~/.venv/bin/activate' >> ~/.bashrc \
    && echo 'source ~/.venv/bin/activate' >> ~/.zshrc # If you use zsh (uncomment if Zsh is enabled)

# Install Python packages into the virtual environment
# Important: pip install must be run within the activated venv
RUN /bin/bash -c "source ~/.venv/bin/activate && pip install --no-cache-dir boto3 botocore aws-requests-auth"
