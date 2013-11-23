
firewall:
  ports:
    - 5432

postgresql_cluster:
  primary_server: 192.168.57.5
  standby_servers:
    - 192.168.57.6
