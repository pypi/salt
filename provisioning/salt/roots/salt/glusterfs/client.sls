
glusterfs-fuse:
  pkg.installed

nfs-utils:
  pkg.installed

rpcbind:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - require:
      - pkg: nfs-utils
      - pkg: rpcbind

#mount -o mountproto=tcp -t nfs 172.16.57.101:/pypi /mnt/pypi

