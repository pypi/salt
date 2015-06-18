
postgresql_cluster:
  primary_server: 172.16.57.12
  standby_servers:
    - 172.16.57.13
  pg_hba:
    pypi:
      database: pypi
      user: pypi
      address: 172.16.57.0/24
      method: md5
  postgresql:
    pg_stat_statements: True

pgpool_cluster:
  nodes:
    - 172.16.57.4
    - 172.16.57.5

