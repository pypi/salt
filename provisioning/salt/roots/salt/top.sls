base:
  '*':
    - base.sanity
  'roles:pypi-mirror':
    - match: grain
    - pypi-mirror
    - firewall
  'roles:pypi':
    - match: grain
    - pypi
    - firewall

  'roles:postgresql_cluster':
    - match: grain
    - firewall
    - postgresql.cluster
