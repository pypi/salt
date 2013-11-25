
gluster_cluster:
  peers:
    - 172.16.57.20
    - 172.16.57.21
    - 172.16.57.22
  bricks:
    /dev/sdb: /data/glusterfs
  volumes:
    pypi:
      replication: 2
      nodes:
        - 172.16.57.20:/data/glusterfs/pypi
        - 172.16.57.21:/data/glusterfs/pypi
        - 172.16.57.22:/data/glusterfs/pypi
      auth_allow: '172.16.57.*'
  virtual_ip:
    172.16.57.101

virtual_ips:
  172.16.57.101:
    auth_pass: muchsecret
    vrid: 52
    cidr: 172.16.57.0/24

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

