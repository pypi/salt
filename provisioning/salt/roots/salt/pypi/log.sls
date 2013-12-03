
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

{% endfor %}
