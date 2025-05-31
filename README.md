# AWS DevOps Dev Container

This repository provides a pre-configured development environment for AWS DevOps tasks, leveraging VS Code Dev Containers. It includes a base Ubuntu image with essential tools like AWS CLI, Terraform, kubectl, Helm, Docker CLI, Python, and more.

The environment is designed to be fully isolated and reproducible, using Docker volumes for persistent storage of user configurations and project repositories.

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
    git clone [https://github.com/YOUR_USERNAME/devops-devcontainer.git](https://github.com/YOUR_USERNAME/devops-devcontainer.git)
    cd devops-devcontainer
    ```
    (Replace `YOUR_USERNAME` with your actual GitHub username or the repository's URL).

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

4.  **Wait for Container Build**:
    * The first time you open the folder in a container, VS Code will build the Docker image (based on `Dockerfile`) and then start the container. This process can take several minutes as it downloads base images and installs all specified tools.
    * You'll see progress updates in the VS Code terminal/output panel.

5.  **Verify the Environment**:
    Once the container is running and VS Code connects to it, open a new terminal in VS Code (Ctrl+\` or `Terminal` > `New Terminal`). You should be logged in as the `devops` user in the `/devops` directory.

    Run the following commands to verify the installation of tools:

    ```bash
    # Check user and current directory
    whoami                 # Should show 'devops'
    pwd                    # Should show '/devops'
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

## Persistent Data & Workspaces

* **`devops-home-volume`**: This Docker volume is mounted to `/home/devops` inside the container. It stores all user-specific configurations, SSH keys, shell history, and dotfiles. This ensures your personal settings persist even if you rebuild the container.
* **`devops-volume`**: This Docker volume is mounted to `/devops` and serves as your primary workspace. All your cloned repositories, project files, and development work should reside here. This volume ensures your project data is preserved.

---

## Customization

### Adding / Removing Tools
To add or remove tools, modify the `Dockerfile` in the root of this repository. After making changes, rebuild the container using `Dev Containers: Rebuild Container` from the VS Code Command Palette.

### VS Code Extensions
To modify the list of recommended VS Code extensions, edit the `extensions` array in `.devcontainer/devcontainer.json`.

---

## Using with Other IDEs (e.g., JetBrains GoLand)

The core components of this Dev Container setup (`Dockerfile` and Docker volumes) are **portable** and can be used with other IDEs that support Docker-based remote development, such as JetBrains products (GoLand, IntelliJ IDEA Ultimate, PyCharm Professional).

While `devcontainer.json` is specific to VS Code, JetBrains IDEs use their own mechanisms (like **JetBrains Gateway** and direct Docker integration) to connect to containers. You would point your JetBrains IDE to the Docker image built from this `Dockerfile` and configure the volume mounts directly within the IDE's remote development setup. The underlying environment and persistence remain the same.

---

Feel free to contribute or suggest improvements to this setup!