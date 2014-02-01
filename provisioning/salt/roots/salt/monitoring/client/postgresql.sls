
/etc/collectd.d/postgresql.conf:
  file.managed:
    - source: salt://monitoring/client/config/collectd.d/postgresql.conf.jinja
    - template: jinja
    - context:
      monitor_host: {{ salt['pillar.get']('monitoring-client-postgresql:host', '127.0.0.1') }}
      monitor_port: {{ salt['pillar.get']('monitoring-client-postgresql:port', '5432') }}
      monitor_user: {{ salt['pillar.get']('monitoring-client-postgresql:user', 'monitoring') }}
      monitor_password: {{ salt['pillar.get']('monitoring-client-postgresql:password', "") }}

collectd-postgresql:
  pkg:
    - installed
