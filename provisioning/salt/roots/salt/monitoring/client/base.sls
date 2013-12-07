
{% set client_config = pillar.get('monitoring_client', {}) %}
{% set bucky_config = pillar.get('bucky', {}) %}

include:
  - supervisor

/etc/bucky/bucky.conf:
  file.managed:
    - source: salt://monitoring/client/config/bucky.conf.jinja
    - template: jinja
    - context:
      graphite_ip: {{ bucky_config.get('graphite_ip', '127.0.0.1') }}
      graphite_port: {{ bucky_config.get('graphite_port', 2003) }}
      graphite_max_reconnects: {{ bucky_config.get('graphite_max_reconnects', 3) }}
      graphite_reconnect_delay: {{ bucky_config.get('graphite_reconnect_delay', 5) }}

python-bucky:
  pkg.installed

/etc/supervisord.d/bucky.ini:
  file.managed:
    - source: salt://monitoring/client/config/bucky.ini

bucky-supervisor:
  cmd.wait:
    - name: supervisorctl reread && supervisorctl update
    - require:
      - file: /etc/supervisord.d/bucky.ini
      - file: /etc/bucky/bucky.conf
      - pkg: python-bucky
    - watch:
      - file: /etc/supervisord.d/bucky.ini

/etc/collectd.conf:
  file.managed:
    - source: salt://monitoring/client/config/collectd.conf.jinja
    - template: jinja
    - context:
      hostname: {{ grains['fqdn'] }}
      collectd_host: {{ client_config.get('collectd_host', '127.0.0.1') }}
      collectd_port: {{ client_config.get('collectd_port', 25826) }}

/etc/collectd.d/base.conf:
  file.managed:
    - source: salt://monitoring/client/config/collectd.d/base.conf

collectd:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - restart: True
    - watch:
      - file: /etc/collectd.conf
      - file: /etc/collectd.d/*
    - require:
      - file: /etc/collectd.conf
