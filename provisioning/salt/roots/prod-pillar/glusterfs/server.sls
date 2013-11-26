
gluster_cluster:
  peers:
    - 172.16.57.6
    - 172.16.57.7
  bricks:
    /dev/xvdc: /data/glusterfs
  volumes:
    pypi:
      replication: 2
      nodes:
        - 172.16.57.6:/data/glusterfs/pypi
        - 172.16.57.7:/data/glusterfs/pypi
      auth_allow: '172.16.57.*'
      network_ping-timeout: 5

firewall:
  gluster_daemon:
    port: 24007
    source: 172.16.57.0/24
  gluster_bricks:
    port: 24009:24015
    source: 172.16.57.0/24
  gluster_nfs:
    port: 34865:34867
    source: 172.16.57.0/24
  portmapper:
    port: 111
    source: 172.16.57.0/24

