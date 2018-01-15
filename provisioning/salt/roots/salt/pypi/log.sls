
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


{% if 'log_archiver' in grains['roles'] %}
/opt/pypi-cdn-log-archiver/env:
  virtualenv.managed:
    - system_site_packages: False

pypi-cdn-log-archiver:
  pip.installed:
    - name: pypi-cdn-log-archiver == 0.1.9
    - bin_env: /opt/pypi-cdn-log-archiver/env
    - require:
      - virtualenv: /opt/pypi-cdn-log-archiver/env
{% endif %}

{% set deploys = {} %}
{% for k,v in pillar.items() %}
  {% if k.startswith('pypi-deploy-') %}
    {% do deploys.update({k: v}) %}
  {% endif %}
{% endfor %}

{% for key, config in deploys.items() %}

{% if 'log_archiver' in grains['roles'] %}
/opt/pypi-cdn-log-archiver/env/bin/{{ config['name'] }}-cdn-log-archiver-wrapper.sh:
  file.managed:
    - source: salt://pypi/config/pypi-cdn-log-archiver-wrapper.sh.jinja
    - template: jinja
    - user: {{ config['user'] }}
    - group: {{ config['group'] }}
    - mode: 0755
    - virtualenv: /opt/pypi-cdn-log-archiver/env
    - context:
      app_key: {{ key }}
      path: {{ config['path'] }}
      pypi_log_bucket: {{ config['cdn_log_archiver']['pypi_log_bucket'] }}
      s3_host: {{ config['cdn_log_archiver']['s3_host'] }}
      debug: {{ config['cdn_log_archiver']['debug'] }}
    - require:
      - user: {{ config['user'] }}
      - group: {{ config['group'] }}
      - virtualenv: /opt/pypi-cdn-log-archiver/env

{{ config['user'] }}-cdn-log-archiver-cron:
  cron.present:
    - name: /opt/pypi-cdn-log-archiver/env/bin/{{ config['name'] }}-cdn-log-archiver-wrapper.sh
    - minute: '0'
    - hour: '4'
    - user: {{ config['user'] }}
{% endif %}

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
