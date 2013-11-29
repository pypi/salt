base:

  '*':
    - networking
    - users
    - sudoers
    - monitoring.client

  'roles:salt-master':
    - match: grain
    - salt-master

  'roles:pypi-mirror':
    - match: grain
    - pypi-mirror
  'roles:pypi':
    - match: grain
    - pypi
    - pypi-deploys.testpypi
    - secrets.testpypi

  'roles:postgresql_cluster':
    - match: grain
    - postgresql.cluster
    - postgresql.postgresql
    - secrets.postgresql

  'roles:postgresql_pgpool':
    - match: grain
    - postgresql.cluster
    - postgresql.pgpool
    - secrets.postgresql

  'roles:gluster_node':
    - match: grain
    - glusterfs.server

  'roles:monitoring_server':
    - match: grain
    - monitoring.server
