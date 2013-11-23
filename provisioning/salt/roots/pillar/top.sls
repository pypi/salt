base:

  '*':
    - networking

  'roles:pypi-mirror':
    - match: grain
    - pypi-mirror
  'roles:pypi':
    - match: grain
    - pypi

  'roles:postgresql_cluster':
    - match: grain
    - postgresql
