
include:
  - nginx
  - supervisor

graphite:
  user:
    - present

{% set graphite_config = pillar.get('graphite', {}) %}
{% set secrets = pillar.get('monitoring_secrets', {}) %}

{% for dir in ['log', 'lib', 'run'] %}
/var/{{ dir }}/graphite-web:
  file.directory:
    - user: graphite
    - group: graphite
    - mode: 755
    - require:
      - pkg: graphite-pkgs
      - user: graphite
{% endfor %}

graphite-web-gunicorn:
  pkg.installed:
    - pkgs:
      - python-gunicorn
      - python-setuptools

/etc/graphite-web/local_settings.py:
  file.managed:
    - source: salt://monitoring/server/config/local_settings.py.jinja
    - template: jinja
    - context:
      secret_key: {{ secrets.get('secret_key') }}
      allowed_hosts: '{{ graphite_config.get('allowed_hosts', '*') }}'
      sqlite3_path: {{ graphite_config.get('sqlite3_path', '/var/lib/graphite-web/graphite.db') }}

graphite-web-init-db:
  cmd.run:
    - name: '/usr/lib/python2.6/site-packages/graphite/manage.py syncdb --noinput'
    - user: graphite
    - cwd: /usr/lib/python2.6/site-packages/graphite

/etc/supervisord.d/graphite-web.ini:
  file.managed:
    - source: salt://monitoring/server/config/graphite-web.ini.jinja
    - template: jinja
    - context:
      program_name: graphite-web
      user: graphite
    - require:
      - service: supervisord

graphite-web-supervisor:
  cmd.wait:
    - name: supervisorctl reread && supervisorctl update
    - require:
      - file: /etc/supervisord.d/graphite-web.ini
      - cmd: graphite-web-init-db
    - watch:
      - file: /etc/supervisord.d/graphite-web.ini

graphite-web-reload:
  cmd.wait:
    - name: 'supervisorctl restart graphite-web'
    - require:
      - cmd: graphite-web-supervisor

/var/log/nginx/graphite-web:
  file.directory

/etc/nginx/conf.d/graphite-web:
  file.directory

/etc/nginx/conf.d/graphite-web/app.conf:
  file.managed:
    - source: salt://monitoring/server/config/graphite-web-app.conf.jinja
    - template: jinja

/etc/nginx/conf.d/graphite-web.conf:
  file.managed:
    - source: salt://monitoring/server/config/graphite-web-nginx.conf.jinja  
    - template: jinja
    - context:
      server_names: {{ ", ".join(secrets.get('server_names')) }}
      https_only: {{ graphite_config.get('https_only', False) }}
    - require:
      - file: /var/log/nginx/graphite-web
      - file: /etc/nginx/conf.d/graphite-web/app.conf
