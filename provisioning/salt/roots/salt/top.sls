base:
  '*':
    - base.sanity
    - users
    - sudoers
    - backup.client
    - monitoring.client.base
    - openvpn.routing

  'roles:salt-master':
    - match: grain
    - firewall

  'roles:pypi-mirror':
    - match: grain
    - pypi-mirror
    - firewall
    - monitoring.client.nginx

  'roles:pypi':
    - match: grain
    - pypi.web
    - firewall
    - monitoring.client.nginx
    - monitoring.client.redis
    - base.auto-highstate

  'roles:pypi_log':
    - match: grain
    - pypi.log
    - firewall
    - monitoring.client.redis
    - base.auto-highstate
    - elasticsearch

  'roles:monitoring_server':
    - match: grain
    - firewall
    - monitoring.server
    - monitoring.client.nginx

  'roles:backup_server':
    - match: grain
    - firewall
    - backup.server
