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
    - pypi.web
    - pypi-deploys.testpypi
    - secrets.testpypi
    - pypi-deploys.pypi
    - secrets.pypi

  'pypi-web0':
    - secrets.backup.pypi-files
    - secrets.backup.testpypi-files

  'G@roles:pypi_log not G@roles:develop':
    - match: compound
    - pypi.log
    - pypi-deploys.testpypi
    - secrets.testpypi
    - pypi-deploys.pypi
    - secrets.pypi

  'G@roles:pypi and G@roles:develop':
    - match: compound
    - pypi.web
    - pypi-deploys.pypi-dev
    - secrets.pypi-dev

  'G@roles:pypi_log and G@roles:develop':
    - match: compound
    - pypi.log
    - pypi-deploys.pypi-dev
    - secrets.pypi-dev

  'roles:postgresql_cluster':
    - match: grain
    - postgresql.cluster
    - postgresql.postgresql
    - secrets.postgresql

  'G@roles:postgresql_cluster and G@roles:primary':
    - match: compound
    - secrets.backup.postgres

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

  'roles:backup_server':
    - match: grain
    - backup.server
