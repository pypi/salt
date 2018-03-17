
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

vm.overcommit_memory:
  sysctl.present:
    - value: 1

redis-daemon:
  service:
    - name: redis
    - running
    - restart: True
    - watch:
      - file: /etc/redis.conf
    - require:
      - pkg: redis28
      - file: /etc/redis.conf
      - sysctl: vm.overcommit_memory

{% set deploys = {} %}
{% for k,v in pillar.items() %}
  {% if k.startswith('pypi-deploy-') %}
    {% do deploys.update({k: v}) %}
  {% endif %}
{% endfor %}

{% for key, config in deploys.items() %}

/etc/rsyslog.d/{{ config['name'] }}.conf:
  file.managed:
    - source: salt://pypi/config/pypi.rsyslog.conf.jinja
    - template: jinja
    - context:
      path: {{ config['path'] }}
      syslog_name: {{ config['fastly_syslog_name'] }}

/etc/logrotate.d/{{ config['name'] }}-cdn:
  file.absent

/etc/logrotate-{{config['name']}}-cdn.conf:
  file.managed:
    - source: salt://pypi/config/pypi-syslog.logrotate.conf
    - template: jinja
    - context:
      syslog_name: {{ config['fastly_syslog_name'] }}

{{config['name']}}-hourly-logrotate-cron:
  cron.present:
    - name: /usr/sbin/logrotate -f /etc/logrotate-{{config['name']}}-cdn.conf
    - minute: '0'
    - user: root

{% if 'cron_workers' in grains['roles'] %}
{{ config['user'] }}-index-for-search-cron:
  cron.present:
    - name: {{ config['path'] }}/env/bin/python {{ config['path'] }}/src/tools/index.py
    - minute: '6'
    - hour: '*/1'
    - user: {{ config['user'] }}

{{ config['user'] }}-index-for-trove-cron:
  cron.present:
    - name: {{ config['path'] }}/env/bin/python {{ config['path'] }}/src/tools/index-trove.py
    - minute: '36'
    - hour: '*/1'
    - user: {{ config['user'] }}
{% endif %}

{% endfor %}
