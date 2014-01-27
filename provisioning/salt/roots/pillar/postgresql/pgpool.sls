
pgpool_cluster:
  nodes:
    - 172.16.57.7
    - 172.16.57.8
  listen_address: 5432
  enable_pool_hba: 'on'
  virtual_ip: 172.16.57.100
  virtual_ip_interface: eth2

firewall:
  pgpool_watchdog:
    port: 9000
  pgpool_heartbeat:
    protocol: udp
    port: 9694
  pgpool_pcp:
    port: 9898
  pgpool_proxy:
    port: 9999
  pgpool_postgres:
    port: 5432

