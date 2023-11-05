# Vagrant Docker Swarm Environment

**Warning: For development only, do not use for production**

This repository contains a Vagrantfile and the necessary configuration files
for automating the setup of a Docker Swarm cluster using Vagrant’s shell
provisioning. You can easily override the default settings for the Vagrant
environment and the Swarm cluster to suit your needs. Customize global
settings via the `.settings.yml` file, and specify per-node overrides using the
`NODES` Ruby hash in `nodes.rb`.

By default, `make` will create three Debian Stable x86_64 Docker Swarm nodes.
Each node will consume:
- 2 threads/cores (depending on architecture)
- 2 GB of RAM
- ~1 GB of storage (base install only)

**Warning: Make sure your machine has enough resources or adjust override settings.**

# Quick Start
Get your Vagrant Docker Swarm cluster up and running with these simple steps:

- Setup the Cluster

  Run the following command to clean any previous setup and start fresh:
  ```bash
  make clean && make
  ```

- SSH into a Node

  Access the first node (`node1`) in your cluster:
  ```bash
  vagrant ssh node1
  ```

- Verify Cluster Setup

  List all the nodes to ensure they've joined the cluster successfully:
  ```bash
  docker node ls
  ```


# Global Overrides
If you wish to override the default settings on a global level,
you can do so by creating a `.settings.yml` file based on the provided
`example-.settings.yml` file:

```bash
cp example-.settings.yml .settings.yml
```

Once you have copied the `example-.settings.yml` to `.settings.yml`, you can
edit it to override the default settings. Below are the available settings:

## Vagrant Settings Overrides
- `VAGRANT_BOX`
  - Default: `debian/bookworm64`
  - Tested most around Debian Stable x86_64 (currently Bookworm)
- `VAGRANT_CPU`
  - Default: `2`
  - Two threads or cores per node, depending on CPU architecture
- `VAGRANT_MEM`
  - Default: `2048`
  - Two GB of RAM per node
- `SSH_FORWARD`
  - Default: `false`
  - Enable this if you need to forward SSH agents to the Vagrant machines

## Docker Swarm Settings Overrides
- `SWARM_NODES`
  - Default: `3`
  - The total number of nodes in your Docker Swarm cluster
- `JOIN_TIMEOUT`
  - Default: `60`
  - Timeout in seconds for nodes to obtain a swarm join token

# Per-Node Overrides
The naming convention for nodes follows a specific pattern: `nodeX`, where `X`
is a number corresponding to the node's position within the cluster. This
convention is strictly adhered to due to the iteration logic within the
`Vagrantfile`, which utilizes a loop iterating over an array range defined by
the number of swarm nodes (`Array(1..SWARM_NODES)`). Each iteration of the loop
corresponds to a node, and the loop counter is in the node name (`nodeX`).

The overrides, if specified in `nodes.rb`, take the highest precedence,
followed by the overrides in `.settings.yml`, and lastly, the defaults hard
coded in the `Vagrantfile` itself. This hierarchy allows for a flexible
configuration where global overrides can be specified in `.settings.yml`, and
more granular, per-node overrides can be defined in `nodes.rb`. If a particular
setting is not overridden in either `.settings.yml` or `nodes.rb`, the default
value from the `Vagrantfile` is used.

If you wish to override the default settings on a per-node level, you can do so
by creating a `nodes.rb` file based on the provided `example-nodes.rb` file:

```bash
cp example-nodes.rb nodes.rb
```

Once you have copied the `example-nodes.rb` to `nodes.rb`, you can edit it to
override the default settings. Below are the available settings available
per-node:

- `BOX`
  - Default: `debian/bookworm64` (or as overridden in `.settings.yml`)
  - Vagrant box or image to be used for the node.
- `CPU`
  - Default: `2` (or as overridden in `.settings.yml`)
  - Defines the number of CPU cores or threads (depending on architecture).
- `MEM`
  - Default: `2048` (2 GB) (or as overridden in `.settings.yml`)
  - Specifies the amount of memory (in MB) allocated to the node.
- `SSH`
  - Default: `false` (or as overridden in `.settings.yml`)
  - Enable this if you need to forward SSH agents to the Vagrant machine

All settings are optional, and as many or as few options can be overridden on
any arbitrary node.
