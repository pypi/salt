base:

  '*':
    - networking
    - users
    - sudoers

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
  'G@roles:postgresql_cluster and G@roles:primary':
    - match: compound
    - secrets.postgresql

  'roles:postgresql_pgpool':
    - match: grain
    - postgresql.cluster
    - postgresql.pgpool

  'roles:gluster_node':
    - match: grain
    - glusterfs.server
