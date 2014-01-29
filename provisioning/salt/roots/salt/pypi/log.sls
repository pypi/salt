
include:
  - redis
  - pypi.base

rsyslog:
  service:
    - running
    - enable: True
    - restart: True
    - watch:
      - file: /etc/rsyslog.d/*.conf

/etc/redis.conf:
  file.comment:
    - regex: "^bind 127.0.0.1$"

redis-bind-all:
  file.append:
    - name: /etc/redis.conf
    - text: "bind 0.0.0.0"

redis-daemon:
  service:
    - name: redis
    - running
    - restart: True
    - watch:
      - file: /etc/redis.conf
    - require:
      - pkg: redis
      - file: /etc/redis.conf

{% set deploys = {} %}
{% for k,v in pillar.items() %}
  {% if k.startswith('pypi-deploy-') %}
    {% do deploys.update({k: v}) %}
  {% endif %}
{% endfor %}

{% for key, config in deploys.items() %}

{{ config['path'] }}/env/bin/rsyslog-cdn-wrapper.sh:
  file.managed:
    - source: salt://pypi/config/rsyslog-cdn-wrapper.sh.jinja
    - template: jinja
    - user: {{ config['user'] }}
    - group: {{ config['group'] }}
    - mode: 755
    - virtualenv: /opt/{{ config['name'] }}/env
    - context:
      path: {{ config['path'] }}
    - require:
      - user: {{ config['user'] }}
      - group: {{ config['group'] }}
      - virtualenv: /opt/{{ config['name'] }}/env

/etc/rsyslog.d/{{ config['name'] }}.conf:
  file.managed:
    - source: salt://pypi/config/pypi.rsyslog.conf.jinja
    - template: jinja
    - context:
      path: {{ config['path'] }}
      syslog_name: {{ config['fastly_syslog_name'] }}

/etc/logrotate.d/{{ config['name'] }}-cdn:
  file.managed:
    - source: salt://pypi/config/pypi-syslog.logrotate.conf
    - template: jinja
    - context:
      syslog_name: {{ config['fastly_syslog_name'] }}

{{ config['user'] }}-integrate-stats-cron:
  cron.present:
    - name: {{ config['path'] }}/env/bin/python {{ config['path'] }}/src/tools/integrate-redis-stats.py
    - minute: '*/15'
    - user: {{ config['user'] }}

{{ config['user'] }}-daily-database-cron:
  cron.present:
    - name: {{ config['path'] }}/env/bin/python {{ config['path'] }}/src/tools/daily.py
    - minute: '0'
    - hour: '6'
    - user: {{ config['user'] }}

{% endfor %}
