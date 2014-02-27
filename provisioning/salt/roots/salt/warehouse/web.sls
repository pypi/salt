
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
      port: 9000

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

unicornherder:
  pip.installed:
    - user: {{ config['name'] }}
    - bin_env: /opt/{{ config['name'] }}/env

gunicorn:
  pip.installed:
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

{% endfor %}
