Purpose
=============
This is a fork of imx-docker from NXP adding support for TN yocto builds.

Usage
=============
Follow normal setup intructions up to and including building the Ubuntu 20 docker image. Note that you may have to re-login to the machine after adding your user to the docker group for new permissions to apply.

Additionally:
```{.sh}
sudo mkdir /opt/yocto
sudo chown ubuntu /opt/yocto
```

Then execute:
```{.sh}
./docker-run.sh imx-5.15.71-2.2.0/yocto-build.sh
```

Notes
--------------
We execute on imx-5.15.71-2.2.0/yocto-build.sh rather than imx-5.15.71-2.2.0-tn/yocto-build.sh however the latter is actually being used. This happens because we mount imx-5.15.71-2.2.0-tn as imx-5.15.71-2.2.0 inside docker to keep the script modifications to a minimum while allowing our and NXPs 5.15 configs of the same version to co-exist in the repo. See env.sh and docker-run.sh changes as appropriate.

Original README
=============

This setup helps to build i.MX BSP in an isolated environment with docker.

Prerequisites
=============

Install Docker
--------------

There are various methods of installing [docker], i.e. by docker script:
  ```{.sh}
  $ curl -fsSL https://get.docker.com -o get-docker.sh
  $ sudo sh get-docker.sh
  ```

Run docker without sudo
-----------------------

To work better with docker, without `sudo`, add your user to `docker group`.
  ```{.sh}
  $ sudo usermod -aG docker <your_user>
  ```

Log out and log back in so that your group membership is re-evaluated.

Set docker to work with proxy
-----------------------------

Create a docker config file at `~/.docker/config.json` and enter the following:

```{.sh}
{
"proxies":
    {
     "default":
         {
          "httpProxy":"http://proxy.example.com:80"
         }
    }
}
```
Note: replace the 'example' proxy with your proxy info.

Create docker service
---------------------
  ```{.sh}
  $ sudo mkdir -p /etc/systemd/system/docker.service.d
  $ sudo vim /etc/systemd/system/docker.service.d/http-proxy.conf
  ```

add the following:

```{.sh}
[Service]
Environment="HTTP_PROXY=http://proxy.example.com:80/"
Environment="NO_PROXY=localhost,someservices.somecompany.com"
```

Restart Docker

```{.sh}
  $ sudo systemctl daemon-reload
  $ sudo systemctl restart docker
```

Build i.MX with docker
======================
```{.sh}
.
├── Dockerfile-Ubuntu-18.04
├── Dockerfile-Ubuntu-20.04
├── Dockerfile-Ubuntu-22.04
├── README.md
├── docker-build.sh
├── docker-run.sh
├── env.sh -> imx-6.6.3-1.0.0/env.sh
└── imx-6.6.3-1.0.0
    ├── env.sh
    └── yocto-build.sh
```

Set variables
-------------

Use `env.sh` to set variables for your build setup. Make sure you have 
created a working directory, owned by current user, on a larger partition.

Create a yocto-ready docker image
---------------------------------

Run `docker-build.sh` with one argument, related to Dockerfile, corresponding 
to the operating system, for example the Dockerfile for Ubuntu version 22.04:

```{.sh}
  $ ./docker-build.sh Dockerfile-Ubuntu-22.04
```

Build the yocto imx-image in a docker container
-----------------------------------------------

```{.sh}
  $ ./docker-run.sh ${IMX_RELEASE}/yocto-build.sh

  i.e IMX_RELEASE=imx-6.6.3-1.0.0
```

or just go to the docker container prompt (and run the build script from there):

```{.sh}
  $ ./docker-run.sh
```

When running, volumes are used to save the build artifacts on host.
  - `{DOCKER_WORKDIR}` as the main workspace
  - `{DOCKER_WORKDIR}/${IMX_RELEASE}` to make available the yocto build scripts 
    into container
  - `{HOME}` to mount the current home user, to make available the user 
    settings inside the container (ssh keys, git config, etc)

[docker]: https://docs.docker.com/engine/install/ubuntu/ "DockerInstall/Ubuntu"
