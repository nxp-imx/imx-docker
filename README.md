# i.MX Yocto Docker Build Environment

This setup helps to build i.MX BSP in an isolated environment with Docker.

## Prerequisites

### Install Docker

There are various methods of installing [docker], i.e. by docker script:

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
```

```bash
sudo sh get-docker.sh
```

### Run docker without sudo

To work better with docker, without `sudo`, add your user to `docker group`.

```bash
sudo usermod -aG docker <your_user>
```

Log out and log back in so that your group membership is re-evaluated.

### Set docker to work with proxy (Optional)

Create a docker config file at `~/.docker/config.json` and enter the following:

```json
{
  "proxies": {
    "default": {
      "httpProxy": "http://proxy.example.com:80"
    }
  }
}
```

Note: replace the 'example' proxy with your proxy info.

### Create docker service for proxy (Optional)

```bash
sudo mkdir -p /etc/systemd/system/docker.service.d
```

```bash
sudo vim /etc/systemd/system/docker.service.d/http-proxy.conf
```

Add the following:

```ini
[Service]
Environment="HTTP_PROXY=http://proxy.example.com:80/"
Environment="NO_PROXY=localhost,someservices.somecompany.com"
```

Restart Docker:

```bash
sudo systemctl daemon-reload
```

```bash
sudo systemctl restart docker
```

## Project Structure

```
.
├── Dockerfile-Ubuntu-18.04
├── Dockerfile-Ubuntu-20.04
├── Dockerfile-Ubuntu-22.04
├── Dockerfile-Ubuntu-24.04
├── README.md
├── config.sh
├── docker-build.sh
├── docker-run.sh
├── versions.txt
└── yocto-build.sh
```

## Configuration

### versions.txt

This file contains the mapping of i.MX versions to their build configurations:

```
# VERSION           UBUNTU  BRANCH                  MANIFEST
6.18.2-1.0.0        24.04   imx-linux-whinlatter    imx-6.18.2-1.0.0.xml
6.6.23-2.0.0        22.04   imx-linux-scarthgap     imx-6.6.23-2.0.0.xml
```

### config.sh

Edit `config.sh` to customize your build environment:

```bash
# Docker configuration
export DOCKER_WORKDIR="${HOME}/yocto-builds"  # Build workspace

# Yocto build configuration
export REMOTE="https://github.com/nxp-imx/imx-manifest"

# Default build configuration (can be overridden)
export MACHINE="${MACHINE:-imx8mpevk}"
export DISTRO="${DISTRO:-fsl-imx-wayland}"
export IMAGES="${IMAGES:-imx-image-core}"
```

**Important:** The `DOCKER_WORKDIR` should be a directory you have write permissions to. Using `${HOME}/yocto-builds` is recommended to avoid permission issues.

## Building i.MX with Docker

### Step 1: Create a Yocto-ready Docker Image

Build the Docker image for your desired i.MX version:

```bash
./docker-build.sh 6.18.2-1.0.0
```

To rebuild without cache:

```bash
./docker-build.sh 6.18.2-1.0.0 --no-cache
```

This will:
- Read the version configuration from `versions.txt`
- Select the appropriate Ubuntu-based Dockerfile
- Install all Yocto build dependencies
- Create a user matching your host UID/GID
- Copy the `yocto-build.sh` script into the image

### Step 2: Run the Build

#### Interactive Shell

Start an interactive shell in the container:

```bash
./docker-run.sh 6.18.2-1.0.0
```

Then manually run the build script:

```bash
yocto-build.sh
```

#### Direct Build

Run the build directly without entering the container:

```bash
./docker-run.sh 6.18.2-1.0.0 yocto-build.sh
```

### Step 3: Customize Build Parameters

You can override default build parameters using environment variables:

```bash
MACHINE=imx8mmevk DISTRO=fsl-imx-xwayland IMAGES=imx-image-full ./docker-run.sh 6.18.2-1.0.0 yocto-build.sh
```

## Volume Mounts

When running the container, the following volumes are mounted:

- `${DOCKER_WORKDIR}:${DOCKER_WORKDIR}` - Main workspace for build artifacts
- `${HOME}/.ssh:${HOME}/.ssh:ro` - SSH keys for Git authentication (read-only)
- `${HOME}/.gitconfig:${HOME}/.gitconfig:ro` - Git configuration (read-only)

Build artifacts will be saved to `${DOCKER_WORKDIR}/imx-<VERSION>/` on your host machine.

## Available Versions

To see all available versions:

```bash
./docker-build.sh
```

or

```bash
./docker-run.sh
```

## Troubleshooting

### Permission Denied Errors

If you encounter permission errors when building, ensure your `DOCKER_WORKDIR` exists and is owned by your user:

```bash
mkdir -p ~/yocto-builds
```

```bash
chown -R $(whoami):$(whoami) ~/yocto-builds
```

### Build Artifacts Location

Build artifacts are located at:
```
${DOCKER_WORKDIR}/imx-<VERSION>/build_<DISTRO>/tmp/deploy/images/<MACHINE>/
```

For example:
```
~/yocto-builds/imx-6.18.2-1.0.0/build_fsl-imx-wayland/tmp/deploy/images/imx8mpevk/
```

### Cleaning Up

To remove a Docker image:

```bash
docker rmi imx-docker:imx-6.18.2-1.0.0
```

To clean up build artifacts:

```bash
rm -rf ~/yocto-builds/imx-6.18.2-1.0.0
```
