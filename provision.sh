#!/bin/bash

######################################
### Install and setup Docker Swarm ###
######################################

# Print commands and exit on error
set -xe

# Install Docker
which curl &>/dev/null || (apt-get update && apt-get install -y curl)
which docker &>/dev/null || curl -fsSL https://get.docker.com | sh
[ ! "$(id -nG vagrant | grep -c docker)" -eq 1 ] && usermod -aG docker vagrant
systemctl enable docker
systemctl start docker

# Setup Docker Swarm
if [ ! "$(docker info | grep -c 'Swarm: active')" -eq 1 ]; then
  # Make hostname: node1 the leader who gives the join token to others
  if [ "$(hostname)" == "node1" ]; then
    docker swarm init | grep -Eo 'docker swarm join .+:[0-9]+' > /vagrant/.swarm
  else
    # Initial delay
    sleep 5
    # Waits JOIN_TIMEOUT of seconds to find the swarm join token before giving up
    START_TIME="$(date +%s)"
    # Wait until .swarm can be found via Vagrant provider file sharing /vagrant
    while [ ! -f /vagrant/.swarm ]; do
      CURRENT_TIME="$(date +%s)"
      DIFF_TIME="$((CURRENT_TIME - START_TIME))"

      # Timeout
      if [ "$DIFF_TIME" -ge "$JOIN_TIMEOUT" ]; then
        echo "[ERROR]: $(hostname) waited $DIFF_TIME/$JOIN_TIMEOUT seconds"
        exit 1
      fi

      # Waiting
      echo "Waiting ($DIFF_TIME/$JOIN_TIMEOUT seconds) for /vagrant/.swarm file"
      sleep 10
    done

    # /vagrant/.swarm file found, so join the swarm
    /bin/bash /vagrant/.swarm
    fi
fi
