base:

  '*':
    - networking

  'roles:pypi-mirror':
    - match: grain
    - pypi-mirror
  'roles:pypi':
    - match: grain
    - pypi

  'roles:postgresql_cluster':
    - match: grain
    - postgresql
    - postgresql.pgpool
  'roles:postgresql_pgpool':
    - match: grain
    - postgresql
    - postgresql.pgpool
