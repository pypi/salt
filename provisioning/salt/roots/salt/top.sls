base:
  '*':
    - base.sanity
    - users
    - sudoers
    - backup.client
    - monitoring.client.base
    - auto-security

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
    - pypi.web
    - firewall
    - monitoring.client.nginx
    - monitoring.client.redis
    - base.auto-highstate

  'G@roles:warehouse':
    - match: compound
    - warehouse.web
    - firewall
    - monitoring.client.nginx
    - base.auto-highstate

  'roles:pypi_log':
    - match: grain
    - pypi.log
    - firewall
    - monitoring.client.redis
    - base.auto-highstate

  'roles:postgresql_cluster':
    - match: grain
    - firewall
    - postgresql.cluster
    - monitoring.client.postgresql
  'roles:postgresql_pgpool':
    - match: grain
    - firewall
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

  'roles:backup_server':
    - match: grain
    - firewall
    - backup.server
