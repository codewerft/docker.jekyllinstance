docker.jekyllinstance
=====================

A Docker container for continuous deployment of git-hosted Jekyll blogs. It automatically pulls, builds and publishes any updates that you push to your blog's Git repository. 

This container is based on Ubuntu 14.04. It runs an Nginx server which exposes the latest build your Jekyll blog on port 80 and a [Git poller script](https://gist.github.com/cwfl/a874c7c1ea782fc066e7) that checks out and periodically pulls and builds your blog's sources.

Install from Docker Registry
----------------------------

We push the latest builds of this container to the [Docker registry](https://registry.hub.docker.com/u/codewerft/docker.jekyllinstance). You can pull it like this:

```
docker pull codewerft/docker.jekyllinstance
```

Build from Source
-----------------

Clone the docker.jekyllinstance repository and build the Docker container:

```
git clone https://github.com/codewerft/docker.jekyllinstance.git
cd docker.jekyllinstance
docker build --rm -t jekyllinstance .
```

Launch a Jekyll Blog Container
------------------------------

Launch a docker.jekyllinstance container and point it to the Git repository where you store your Jekyll blog. The following options can be passed to the container:

* WI_REPOSITORY - The URL of the Git repository you want to deploy.
* WI_BRANCH - The repository branch you want to deploy (default: master).
* WI_OAUTH - The OAuth token to access your repository in case it is private.
* WI_POLL_INTERVAL - Repository poll interval in minutes (default: 5).

```
docker run -p 127.0.0.1:6000:80 \
  --name=myblog -d codewerft/docker.jekyllinstance \
  -e WI_REPOSITORY==https://github.com/user/myblog.git \
  -e WI_BRANCH=master \
  -e WI_OAUTH=secret
```

In this example, port 80 of the container’s Nginx server is exposed locally on port 6000, so you should be able to connect to it, e.g., via lynx: `lynx http://localhost:6000.`

