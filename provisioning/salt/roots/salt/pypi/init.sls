
include:
  - python.27.virtualenv
  - python.27.m2crypto
  - pkg.hg
  - nginx
  - redis
  - glusterfs.client
  - supervisor
{% if 'develop' in grains['roles'] %}
  - postgresql.93
  - pypi.dev-db
{% endif %}

pypi-system-deps:
  pkg.installed:
    - pkgs:
      - python27-devel
      - postgresql-devel
      - gcc
    - require:
      - pkgrepo: python27-el6

{% set deploys = {} %}
{% for k,v in pillar.items() %}
  {% if k.startswith('pypi-deploy-') %}
    {% do deploys.update({k: v}) %}
  {% endif %}
{% endfor %}

{% for key, config in deploys.items() %}

{{ config['name'] }}-user:
  group.present:
    - name: {{ config['group'] }}
    - gid: {{ config['group_gid'] }}
  user.present:
    - name: {{ config['user'] }}
    - uid: {{ config['user_uid'] }}
    - gid: {{ config['group_gid'] }}
    - home: {{ config['path'] }}
    - createhome: True
    - require:
      - group: {{ config['group'] }}

{{ config['path'] }}:
  file.directory:
    - user: {{ config['user'] }}
    - group: {{ config['group'] }}
    - mode: 755

/var/log/{{ config['name'] }}:
  file.directory:
    - user: {{ config['user'] }}
    - group: {{ config['group'] }}
    - mode: 750

/var/run/{{ config['name'] }}:
  file.directory:
    - user: {{ config['user'] }}
    - group: {{ config['group'] }}
    - mode: 755


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

/etc/nginx/conf.d/{{ config['name'] }}/app.conf:
  file.managed:
    - source: salt://pypi/config/pypi.nginx.app.conf.jinja
    - template: jinja
    - context:
      app_key: {{ key }}
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

{{ config['name'] }}-source:
  hg.latest:
    - name: https://bitbucket.org/pypa/pypi
    - rev: tip
    - target: {{ config['path'] }}/src
    - user: {{ config['name'] }}
    - require:
      - user: {{ config['name'] }}
      - file: {{ config['path'] }}

/opt/{{ config['name'] }}/env:
  virtualenv.managed:
    - venv_bin: virtualenv-2.7
    - python: python2.7
    - system_site_packages: True
    - user: {{ config['name'] }}
    - cwd: {{ config['path'] }}/src
    - requirements: {{ config['path'] }}/src/requirements.txt
    - require:
      - file: {{ config['path'] }}
      - hg: {{ config['name'] }}-source
      - user: {{ config['user'] }}
      - pip: virtualenv-2.7
      - pkg: python27-m2crypto
      - pkg: pypi-system-deps

{{ config['path'] }}/src/config.ini:
  file.managed:
    - source: salt://pypi/config/pypi.ini.jinja
    - user: {{ config['name'] }}
    - group: {{ config['name'] }}
    - mode: 640
    - template: jinja
    - context:
      app_key: {{ key }}
    - require:
      - file: /var/log/{{ config['name'] }}
      - file: /var/run/{{ config['name'] }}
      - virtualenv: {{ config['path'] }}/env

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

{% endfor %}
