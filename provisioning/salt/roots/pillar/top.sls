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

  'G@roles:pypi not G@roles:develop':
    - match: compound
    - pypi
    - pypi-deploys.testpypi
    - secrets.testpypi

  'G@roles:pypi and G@roles:develop':
    - match: compound
    - pypi
    - pypi-deploys.pypi-dev
    - secrets.pypi-dev

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
    - secrets.monitoring
