
firewall:
  salt_master_pypi_internal:
    port: 4505:4506
    source: 172.16.57.0/24
  salt_master_remote:
    port: 4505:4506
    source: 166.78.174.125
