
include:
  - glusterfs.base

ignore-centos-gluster:
  cmd.run:
    - name: yum-config-manager base --setopt=base.exclude=glusterfs\* --save
    - unless: yum-config-manager base | grep -Pzo 'glusterfs\*'

ignore-centos-updates-gluster:
  cmd.run:
    - name: yum-config-manager updates --setopt=updates.exclude=glusterfs\* --save
    - unless: yum-config-manager updates | grep -Pzo 'glusterfs\*'

glusterfs-fuse:
  pkg:
    - installed
    - require:
      - pkgrepo: gluster-el6
