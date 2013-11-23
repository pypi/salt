
firewall:
  ports:
    - 5432

postgresql_cluster:
  primary_server: 10.10.10.5
  standby_servers:
    - 10.10.10.6
