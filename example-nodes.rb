#########################
### Example overrides ###
#########################

# This configuration as-is will take 10 threads/cores and 10 GB of RAM assuming
# that .settings.yml isn't overriding the defaults. Make sure you have enough
# resources before running something like this.

# Don't forget to set SWARM_NODES in .settings
# if you run more/less than 3 nodes

NODES = {
  # CPU/MEM heavy node
  'node1' => {
    #'BOX'  => 'debian/bookworm64',
    'CPU' => 4,
    'MEM'  => 4096,
    'SSH'  => true
  },
  # Memory heavy node
  'node2' => {
    'BOX'  => 'debian/bookworm64',
    #'CPU' => 4,
    'MEM'  => 4096,
    #'SSH'  => true
  },
  # CPU heavy node
  'node3' => {
    'BOX'  => 'debian/bookworm64',
    'CPU' => 4,
    #'MEM'  => 4096,
    #'SSH'  => true
  }
}
