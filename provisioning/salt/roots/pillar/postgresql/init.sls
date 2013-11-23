
firewall:
  ports:
    - 5432
    - 9000
    - 9694
    - 9898
    - 9999

postgresql_cluster:
  primary_server: 172.16.57.5
  standby_servers:
    - 172.16.57.6

pgpool_cluster:
  nodes:
    - 172.16.57.5
    - 172.16.57.6
