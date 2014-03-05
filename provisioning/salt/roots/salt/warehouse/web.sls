
include:
  - nginx
  - supervisor
  - warehouse.base
  - elasticsearch

{% set deploys = {} %}
{% for k,v in pillar.items() %}
  {% if k.startswith('warehouse-deploy-') %}
    {% do deploys.update({k: v}) %}
  {% endif %}
{% endfor %}

{% for key, config in deploys.items() %}

/var/log/nginx/{{ config['name'] }}:
  file.directory

/etc/nginx/conf.d/{{ config['name'] }}:
  file.directory

/etc/nginx/conf.d/{{ config['name'] }}/app.conf:
  file.managed:
    - source: salt://warehouse/config/nginx.app.conf.jinja
    - template: jinja
    - context:
      app_name: {{ config['name'] }}

/etc/nginx/conf.d/{{ config['name'] }}.conf:
  file.managed:
    - source: salt://warehouse/config/nginx.conf.jinja
    - template: jinja
    - context:
      app_name: {{ config['name'] }}
      port: {{ config ['port'] }}

/opt/{{ config['name'] }}/gunicorn.py:
  file.managed:
    - source: salt://warehouse/config/unicorn.py.template
    - template: jinja
    - context:
      app_name: {{ config['name'] }}
      workers: {{ config.get('workers', 2) }}
    - require:
      - file: /var/log/{{ config['name'] }}
      - file: /var/run/{{ config['name'] }}

{{ config['name'] }}-psutil:
  pip.installed:
    - name: psutil
    - user: {{ config['name'] }}
    - bin_env: /opt/{{ config['name'] }}/env

{{ config['name'] }}-unicornherder:
  pip.installed:
    - name: unicornherder
    - user: {{ config['name'] }}
    - bin_env: /opt/{{ config['name'] }}/env

{{ config['name'] }}-gunicorn:
  pip.installed:
    - name: gunicorn
    - user: {{ config['name'] }}
    - bin_env: /opt/{{ config['name'] }}/env

/etc/supervisord.d/{{ config['name'] }}.ini:
  file.managed:
    - source: salt://warehouse/config/supervisor.ini.jinja
    - user: root
    - group: root
    - mode: 640
    - template: jinja
    - context:
      app_name: {{ config['name'] }}
      app_module: warehouse.wsgi
    - require:
      - file: /var/log/{{ config['name'] }}
      - virtualenv: {{ config['path'] }}/env

{{ config['name'] }}-supervisor:
  cmd.wait:
    - name: supervisorctl reread && supervisorctl update
    - require:
      - file: /etc/supervisord.d/{{ config['name'] }}.ini
    - watch:
      - file: /etc/supervisord.d/{{ config['name'] }}.ini

{{ config['name'] }}-reload:
  cmd.wait:
    - name: kill -HUP $(cat /var/run/{{ config['name'] }}/gunicorn.pid)
    - require:
      - git: {{ config['name'] }}-source
      - pip: /opt/{{ config['name'] }}/src
      - file: /etc/warehouse/{{ config['name'] }}.yml
    - watch:
      - git: {{ config['name'] }}-source
      - file: /etc/warehouse/{{ config['name'] }}.yml

{{ config['name'] }}-reindex:
  cron.present:
    - name: "/opt/{{ config['name'] }}/env/bin/warehouse -c /etc/warehouse/{{ config['name'] }}.yml search reindex"
    - minute: '0'
    - user: {{ config['name'] }}


{% endfor %}
