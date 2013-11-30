base:
  '*':
    - base.sanity
    - users
    - sudoers
    - monitoring.client.base

  'roles:salt-master':
    - match: grain
    - firewall

  'roles:pypi-mirror':
    - match: grain
    - pypi-mirror
    - firewall
    - monitoring.client.nginx
  'roles:pypi':
    - match: grain
    - pypi
    - firewall
    - monitoring.client.nginx

  'roles:postgresql_cluster':
    - match: grain
    - firewall
    - postgresql.cluster
  'roles:postgresql_pgpool':
    - match: grain
    - firewall
    - keepalived
    - postgresql.cluster.pgpool

  'roles:gluster_node':
    - match: grain
    - glusterfs.server
  'roles:gluster_client':
    - match: grain
    - glusterfs.client

  'roles:monitoring_server':
    - match: grain
    - firewall
    - monitoring.server
    - monitoring.client.nginx
