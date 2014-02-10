
postgresql_cluster:
  primary_server: 172.16.57.5
  standby_servers:
    - 172.16.57.6
  pg_hba:
    testpypi:
      database: testpypi
      user: testpypi
      address: 172.16.57.0/24
      method: md5
    pypi:
      database: pypi
      user: pypi
      address: 172.16.57.0/24
      method: md5
  postgresql:
    shared_buffers: 128MB
    work_mem: 32MB
    maintenance_work_mem: 50MB
    effective_cache_size: 256MB

pgpool_cluster:
  nodes:
    - 172.16.57.7
    - 172.16.57.8

