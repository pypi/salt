
include:
  - python.pypy

{% set deploys = {} %}
{% for k,v in pillar.items() %}
  {% if k.startswith('warehouse-deploy-') %}
    {% do deploys.update({k: v}) %}
  {% endif %}
{% endfor %}

{% for key, config in deploys.items() %}

{{ config['name'] }}-user:
  group.present:
    - name: {{ config['group'] }}
    - gid:  {{ config['group_gid'] }}
  user.present:
    - name: {{ config['user'] }}
    - uid:  {{ config['user_uid'] }}
    - gid:  {{ config['group_gid'] }}
    - home: {{ config['path'] }}
    - createhome: True
    - require:
      - group: {{ config['group'] }}

{{ config['path'] }}:
  file.directory:
    - user:  {{ config['user'] }}
    - group: {{ config['group'] }}
    - mode: 755

/var/log/{{ config['name'] }}:
  file.directory:
    - user:  {{ config['user'] }}
    - group: {{ config['group'] }}
    - mode: 750

/var/run/{{ config['name'] }}:
  file.directory:
    - user:  {{ config['user'] }}
    - group: {{ config['group'] }}
    - mode: 755

/opt/{{ config['name'] }}/env:
  virtualenv.managed:
    - venv_bin: virtualenv-pypy
    - python: pypy
    - system_site_packages: False
    - user: {{ config['name'] }}
    - cwd:  {{ config['path'] }}/src
    - require:
      - file: {{ config['path'] }}
      - user: {{ config['user'] }}

{{ config['name'] }}-source:
  git.latest:
    - name: {{ config.get('source_uri', "https://github.com/pypa/warehouse.git") }}
    - rev: {{ config.get('source_rev', "master") }}
    - user: {{ config['name'] }}
    - target: /opt/{{ config['name'] }}/src

{{ config['name'] }}-package:
  pip.installed:
    - name: /opt/{{ config['name'] }}/src
    - user: {{ config['name'] }}
    - bin_env: /opt/{{ config['name'] }}/env

/etc/warehouse/{{ config['name'] }}.yml:
  file.serialize:
    - formatter: json
    - dataset: {{ config['config'] }}

{% endfor %}
