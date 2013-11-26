base:

  '*':
    - networking
    - users
    - sudoers

  'roles:pypi-mirror':
    - match: grain
    - pypi-mirror
  'roles:pypi':
    - match: grain
    - pypi

  'roles:postgresql_cluster':
    - match: grain
    - postgresql.cluster
    - postgresql.postgresql
  'roles:postgresql_pgpool':
    - match: grain
    - postgresql.cluster
    - postgresql.pgpool
