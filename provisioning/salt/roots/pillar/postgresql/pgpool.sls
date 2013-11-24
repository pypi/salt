
pgpool_cluster:
  nodes:
    - 172.16.57.7
    - 172.16.57.8
  virtual_ip:
    172.16.57.100

virtual_ips:
  172.16.57.100:
    auth_pass: sosecret
    vrid: 51
    cidr: 172.16.57.0/24

firewall:
  ports:
    - 9000
    - 9694
    - 9898
    - 9999
    - 5432

