
datadog_tags:
  - service:pypi
  - role:salt-master

firewall:
  salt_master_pypi_internal:
    port: 4505:4506
    source: 172.16.57.0/24
  salt_master_remote_backup:
    port: 4505:4506
    source: 166.78.184.219
  salt_master_ord_mirror:
    port: 4505:4506
    source: 23.253.174.176
