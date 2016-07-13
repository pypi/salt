base:

  '*':
    - networking
    - users
    - sudoers
    - monitoring.client

  'roles:salt-master':
    - match: grain
    - salt-master

  'roles:pypi-mirror':
    - match: grain
    - pypi-mirror
    - monitoring.client.dfw

  'G@roles:pypi not G@roles:develop':
    - match: compound
    - pypi.web
    - pypi-deploys.testpypi
    - secrets.testpypi
    - pypi-deploys.pypi
    - secrets.pypi

  'G@roles:pypi_log not G@roles:develop':
    - match: compound
    - pypi.log
    - pypi-deploys.testpypi
    - secrets.testpypi
    - pypi-deploys.pypi
    - secrets.pypi
    - secrets.backup.counter-redis

  'G@roles:pypi and G@roles:develop':
    - match: compound
    - pypi.web
    - pypi-deploys.pypi-dev
    - secrets.pypi-dev

  'G@roles:pypi_log and G@roles:develop':
    - match: compound
    - pypi.log
    - pypi-deploys.pypi-dev
    - secrets.pypi-dev

  'roles:monitoring_server':
    - match: grain
    - monitoring.server

  'roles:backup_server':
    - match: grain
    - backup.server
    - monitoring.client.dfw
