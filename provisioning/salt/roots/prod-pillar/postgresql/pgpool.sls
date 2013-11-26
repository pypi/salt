
pgpool_cluster:
  nodes:
    - None
    - None
  virtual_ip:
    172.16.57.100

virtual_ips:
  172.16.57.100:
    auth_pass: sosecret
    vrid: 51
    cidr: 172.16.57.0/24

firewall:
  pgpool_watchdog:
    port: 9000
    source: source: 172.16.57.0/24
  pgpool_heartbeat:
    protocol: udp
    port: 9694
    source: source: 172.16.57.0/24
  pgpool_pcp:
    port: 9898
    source: source: 172.16.57.0/24
  pgpool_proxy:
    port: 9999
    source: source: 172.16.57.0/24
  pgpool_postgres:
    port: 5432
    source: source: 172.16.57.0/24

