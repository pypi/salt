
include:
  - pypi.base
  - nginx
  - redis
  - glusterfs.client
  - supervisor
{% if 'develop' in grains['roles'] %}
  - postgresql.93
  - pypi.dev-db
{% endif %}

{% set deploys = {} %}
{% for k,v in pillar.items() %}
  {% if k.startswith('pypi-deploy-') %}
    {% do deploys.update({k: v}) %}
  {% endif %}
{% endfor %}

{% for key, config in deploys.items() %}

  {% if config['data_device']['type'] == "local" %}

{{ config['data_mount'] }}:
  file.directory:
    - user: {{ config['user'] }}
    - group: {{ config['group'] }}
    - mode: 755
    - makedirs: True
    - require:
      - user: {{ config['user'] }}

  {% else %}

{{ config['data_mount'] }}:
  mount.mounted:
    - device: {{ config['data_device']['uri'] }}
    - fstype: {{ config['data_device']['type'] }}
    - mkmnt: True
    - opts:
      - defaults
  file.directory:
    - user: {{ config['user'] }}
    - group: {{ config['group'] }}
    - mode: 755
    - require:
      - user: {{ config['user'] }}

  {% endif %}

/var/log/nginx/{{ config['name'] }}:
  file.directory:
    - user: root
    - group: root

/etc/nginx/conf.d/{{ config['name'] }}.conf:
  file.managed:
    - source: salt://pypi/config/pypi.nginx.conf.jinja
    - template: jinja
    - context:
      app_key: {{ key }}
    - user: root
    - group: root
    - mode: 640

/etc/nginx/conf.d/{{ config['name'] }}:
  file.directory


{% if config.get('rate_limit', False) %}
/etc/nginx/conf.d/{{ config['name'] }}-ratelimit.conf:
  file.managed:
    - source: salt://pypi/config/pypi.nginx.ratelimit.conf.jinja
    - template: jinja
    - context:
      zone_name: {{ config['name'] }}
      zone_size: {{ config.get('rate_limit', {}).get('zone_size', '10m') }}
      max_rate: {{ config.get('rate_limit', {}).get('max_rate', '1r/s') }}
{% endif %}

/etc/nginx/conf.d/{{ config['name'] }}/app.conf:
  file.managed:
    - source: salt://pypi/config/pypi.nginx.app.conf.jinja
    - template: jinja
    - context:
      app_key: {{ key }}
{% if config.get('rate_limit', False) %}
      rate_limit: True
      zone_name: {{ config['name'] }}
      burst: {{ config.get('rate_limit', {}).get('burst', 3) }}
{% endif %}
    - user: root
    - group: root
    - mode: 640
    - require:
      - file: /etc/nginx/conf.d/{{ config['name'] }}
      - file: /etc/nginx/conf.d/{{ config['name'] }}.conf
      - file: /var/log/nginx/{{ config['name'] }}

/etc/logrotate.d/{{ config['name'] }}:
  file.managed:
    - source: salt://pypi/config/pypi.logrotate.conf
    - template: jinja
    - context:
      app_key: {{ key }}
    - user: root
    - group: root
    - mode: 644

{{ config['path'] }}/secret:
  file.directory:
    - user: {{ config['name'] }}
    - group: {{ config['group'] }}
    - mode: 700

{{ config['path'] }}/secret/pubkey:
  file.managed:
    - user: {{ config['name'] }}
    - group: {{ config['group'] }}
    - mode: 600
    - contents_pillar: secrets-{{ key }}:pubkey
    - require:
      - file: {{ config['path'] }}/secret

{{ config['path'] }}/secret/privkey:
  file.managed:
    - user: {{ config['name'] }}
    - group: {{ config['group'] }}
    - mode: 600
    - contents_pillar: secrets-{{ key }}:privkey
    - require:
      - file: {{ config['path'] }}/secret

/etc/init.d/{{ config['name'] }}:
  file.managed:
    - source: salt://pypi/config/pypi.initd.jinja
    - template: jinja
    - context:
      app_key: {{ key }}
    - user: root
    - group: root
    - mode: 755
    - template: jinja
    - require:
      - file: {{ config['path'] }}/src/config.ini

/etc/supervisord.d/{{ config['name'] }}-worker.ini:
  file.managed:
    - source: salt://pypi/config/pypi-worker.ini.jinja
    - user: root
    - group: root
    - mode: 640
    - template: jinja
    - context:
      app_key: {{ key }}
    - require:
      - file: /var/log/{{ config['name'] }}
      - file: {{ config['path'] }}/src/config.ini
      - virtualenv: {{ config['path'] }}/env

{{ config['name'] }}-supervisor:
  cmd.wait:
    - name: supervisorctl reread && supervisorctl update
    - require:
      - file: /etc/supervisord.d/{{ config['name'] }}-worker.ini
    - watch:
      - file: /etc/supervisord.d/{{ config['name'] }}-worker.ini

{{ config['name'] }}-service:
  service:
    - name: {{ config['name'] }}
    - running
    - enable: True
    - require:
      - file: /etc/init.d/{{ config['name'] }}

{{ config['name'] }}-reload:
  cmd.wait:
    - name: 'service {{ config['name'] }} reload && supervisorctl restart {{ config['name'] }}-worker'
    - require:
      - service: {{ config['name'] }}-service
      - cmd: {{ config['name'] }}-supervisor
    - watch:
       - hg: {{ config['name'] }}-source
       - file: {{ config['path'] }}/src/config.ini

{% endfor %}
