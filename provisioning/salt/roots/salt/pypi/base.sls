
include:
  - python.27.virtualenv
  - python.27.m2crypto
  - pkg.hg

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

{% endfor %}
