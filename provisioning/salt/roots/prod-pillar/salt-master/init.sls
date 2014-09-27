
firewall:
  salt_master_pypi_internal:
    port: 4505:4506
    source: 172.16.57.0/24
  salt_master_remote_backup:
    port: 4505:4506
    source: 23.253.80.94
  salt_master_syd_mirror:
    port: 4505:4506
    source: 119.9.24.35
  salt_master_hkg_mirror:
    port: 4505:4506
    source: 119.9.93.202
  salt_master_dfw_mirror:
    port: 4505:4506
    source: 23.253.244.33
