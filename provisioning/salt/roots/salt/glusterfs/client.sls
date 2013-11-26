
include:
  - glusterfs.base

glusterfs-fuse:
  pkg:
    - installed
    - require:
      - pkgrepo: gluster-el6
