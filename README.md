# AWS DevOps Dev Container

This repository provides a pre-configured development environment for AWS DevOps tasks, leveraging VS Code Dev Containers. It includes a base Ubuntu image with essential tools like AWS CLI, Terraform, kubectl, Helm, Docker CLI, Python, and more.

The environment is designed to be fully isolated and reproducible. **The Docker image for this Dev Container is pre-built and hosted on Docker Hub, eliminating the need for local image builds and ensuring consistent environments.**

---

## Features

* **Ubuntu Base Image**: A clean and stable Ubuntu environment.
* **DevOps Tooling**:
    * **AWS CLI v2**: Command-line interface for Amazon Web Services.
    * **Terraform**: Infrastructure as Code tool from HashiCorp.
    * **Kubectl**: Kubernetes command-line tool.
    * **Helm**: The package manager for Kubernetes.
    * **Docker CLI**: For interacting with the Docker daemon on your host machine (Docker-from-Docker setup).
    * **jq**: Lightweight and flexible command-line JSON processor.
    * **yq**: Portable YAML processor.
    * **Git**: Version control system.
    * **`sudo`**: Pre-configured for the `devops` user with NOPASSWD.
* **Python Environment**:
    * Python 3 and `pip`.
    * Isolated **virtual environment** (`~/.venv`) for project-specific Python packages (e.g., `boto3`, `botocore`, `aws-requests-auth`).
    * Virtual environment automatically activated in new terminal sessions.
* **VS Code Extensions**: Recommended VS Code extensions for Docker, Terraform, Kubernetes, AWS Toolkit, Python, and YAML are pre-configured to install automatically.
* **Persistent Data**: Uses Docker volumes to ensure your home directory settings (`devops-home-volume`) and workspace data (`devops-volume`) persist across container restarts and rebuilds.

---

## Prerequisites

Before you begin, ensure you have the following installed on your **Windows** machine:

1.  **[Docker Desktop](https://www.docker.com/products/docker-desktop/)**: Make sure it's running and WSL 2 backend is enabled (this is usually default).
2.  **[Visual Studio Code](https://code.visualstudio.com/)**: Your primary IDE for connecting to the Dev Container.
3.  **VS Code Dev Containers Extension**: Open VS Code, go to Extensions (Ctrl+Shift+X), search for "Dev Containers" (by Microsoft), and install it.

---

## Setup and Usage

Follow these steps to get your AWS DevOps Dev Container up and running:

1.  **Clone this Repository**:
    ```bash
    git@github.com:optimist991/devops-devcontainer.git
    cd devops-devcontainer
    ```

2.  **Create Docker Volumes (Optional but Recommended)**:
    While VS Code Dev Containers can create volumes automatically, it's good practice to create them manually first for clarity and control.
    ```bash
    docker volume create devops-home-volume
    docker volume create devops-volume
    ```

3.  **Open in VS Code**:
    * Open Visual Studio Code.
    * Go to `File` > `Open Folder...` and select the `devops-devcontainer` folder you just cloned.
    * VS Code should detect the `.devcontainer` folder and prompt you to "Reopen in Container" (or "Open Folder in Container"). Click this button.
    * If you don't see the prompt, open the Command Palette (Ctrl+Shift+P or F1) and type `Dev Containers: Reopen in Container`.

4.  **Wait for Container Setup**:
    * The first time you open the folder in a container, VS Code will **pull the pre-built Docker image from Docker Hub**. This process is generally much faster than building locally.
    * You'll see progress updates as the image is downloaded and the container starts.

5.  **Verify the Environment**:
    Once the container is running and VS Code connects to it, open a new terminal in VS Code (Ctrl+\` or `Terminal` > `New Terminal`). You should be logged in as the `devops` user in the `/devops` directory.

    Run the following commands to verify the installation of tools:

    ```bash
    # Check user and current directory
    whoami          # Should show 'devops'
    pwd             # Should show '/devops'
    ls -la /home/devops    # Verify home directory contents (e.g., .bashrc, .venv)

    # Check Ubuntu version
    lsb_release -a

    # Check AWS CLI
    aws --version
    aws configure list # Will show empty config if not set yet

    # Check Terraform
    terraform version

    # Check Kubectl
    kubectl version --client

    # Check Helm
    helm version

    # Check Docker CLI (Docker-from-Docker)
    docker version        # Should show client and server details (server is your host Docker Desktop)
    docker ps             # Should list containers running on your host

    # Check jq and yq
    jq --version
    yq --version

    # Check Python and Virtual Environment
    python3 --version
    which python3         # Should point to a path inside ~/.venv (e.g., /home/devops/.venv/bin/python3)
    pip --version         # Should indicate pip is for your virtual environment
    pip list              # Should list boto3, botocore, aws-requests-auth
    ```

---

## Image Management and Updates

The Docker image for this Dev Container is built and pushed to **Docker Hub** via **GitHub Actions**.

* **Docker Hub Repository**: `optimist991/devcontainer`
* **Versioning**:
    * Images are tagged with `latest` (always pointing to the most recent successful build) and an incremental tag like `[GitHub_Run_Number]-[Short_Commit_SHA]` (e.g., `123-abcdef7`).
* **Automatic Builds**:
    * The GitHub Actions workflow `build-devcontainer-image.yml` (located in `.github/workflows/`) is configured to automatically build and push a new image to Docker Hub whenever:
        * Changes are pushed to the `main` branch that affect `Dockerfile` or `.devcontainer/devcontainer.json`.
        * A Pull Request is opened or updated targeting the `main` branch that affects `Dockerfile` or `.devcontainer/devcontainer.json`.
* **Manual Builds**: You can also manually trigger the GitHub Action via the "workflow_dispatch" event in the GitHub Actions tab.

When the Dev Container starts in VS Code, it pulls the `latest` image from `optimist991/devcontainer` on Docker Hub, ensuring you always have the most up-to-date environment.

---

## Persistent Data & Workspaces

* **`devops-home-volume`**: This Docker volume is mounted to `/home/devops` inside the container. It stores all user-specific configurations, SSH keys, shell history, and dotfiles. This ensures your personal settings persist even if you rebuild the container.
* **`devops-volume`**: This Docker volume is mounted to `/devops` and serves as your primary workspace. All your cloned repositories, project files, and development work should reside here. This volume ensures your project data is preserved.

---

## Customization

### Adding / Removing Tools
To add or remove tools, modify the `Dockerfile` in the root of this repository. Your changes will trigger a new image build on GitHub Actions, which will then be available on Docker Hub for your Dev Container.

### VS Code Extensions
To modify the list of recommended VS Code extensions, edit the `extensions` array in `.devcontainer/devcontainer.json`.

---

## Using with Other IDEs (e.g., JetBrains GoLand)

The core components of this Dev Container setup (`Dockerfile` and Docker volumes) are **portable** and can be used with other IDEs that support Docker-based remote development, such as JetBrains products (GoLand, IntelliJ IDEA Ultimate, PyCharm Professional).

While `devcontainer.json` is specific to VS Code, JetBrains IDEs use their own mechanisms (like **JetBrains Gateway** and direct Docker integration) to connect to containers. You would point your JetBrains IDE to the Docker image `optimist991/devcontainer:latest` (or a specific version tag) and configure the volume mounts directly within the IDE's remote development setup. The underlying environment and persistence remain the same.

---

Feel free to contribute or suggest improvements to this setup!