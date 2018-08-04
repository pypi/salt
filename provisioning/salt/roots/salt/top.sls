base:
  '*':
    - base.sanity
    - datadog
    - users
    - sudoers
    - backup.client
    - monitoring.client.base
    - openvpn.routing

  'roles:salt-master':
    - match: grain
    - firewall
    - cdn

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

  'G@roles:warehouse':
    - match: compound
    - warehouse.web
    - firewall
    - monitoring.client.nginx
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
