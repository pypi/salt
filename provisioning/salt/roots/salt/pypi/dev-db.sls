{% set deploys = {} %}
{% for k,v in pillar.items() %}
  {% if k.startswith('pypi-deploy-') %}
    {% do deploys.update({k: v}) %}
  {% endif %}
{% endfor %}

postgresql:
  pkg.installed

pypi_postgres_contrib:
  pkg.installed:
    - name: postgresql93-contrib

pypi_postgres_pg_hba:
  file.managed:
    - name: /var/lib/pgsql/9.3/data/pg_hba.conf
    - source: salt://pypi/config/test-pg_hba.conf
    - user: postgres
    - group: postgres
    - mode: 600
    - require:
      - pkg: postgresql93-server
      - cmd: postgresql93-server

{% for key, config in deploys.items() %}
{% set secrets = salt['pillar.get']("secrets-"+key) %}

{{ config['name'] }}_dev_postgres_user:
  postgres_user.present:
    - name: {{ secrets['postgresql']['user'] }}
    - password: {{ secrets['postgresql']['password'] }}
    - user: postgres
    - require:
      - service: postgresql-9.3
      - pkg: postgresql

{{ config['name'] }}_postgres_database:
  postgres_database.present:
    - name: {{ secrets['postgresql']['database'] }}
    - owner: {{ secrets['postgresql']['user'] }}
    - require:
      - postgres_user: {{ config['name'] }}_dev_postgres_user

{{ config['name'] }}_postgres_citext:
  cmd.wait:
    - name: 'psql {{ secrets['postgresql']['database'] }} -c "CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;"'
    - user: postgres
    - require:
      - postgres_database: {{ config['name'] }}_postgres_database
      - postgres_user: {{ config['name'] }}_dev_postgres_user
      - pkg: pypi_postgres_contrib
    - watch:
      - postgres_database: {{ config['name'] }}_postgres_database
      - postgres_user: {{ config['name'] }}_dev_postgres_user
      - pkg: pypi_postgres_contrib

{{ config['name'] }}_postgres_plpgsql:
  cmd.wait:
    - name: 'psql {{ secrets['postgresql']['database'] }} -c "CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;"'
    - user: postgres
    - require:
      - postgres_database: {{ config['name'] }}_postgres_database
      - postgres_user: {{ config['name'] }}_dev_postgres_user
    - watch:
      - postgres_database: {{ config['name'] }}_postgres_database
      - postgres_user: {{ config['name'] }}_dev_postgres_user

{{ config['path'] }}/.pgpass:
  file.managed:
    - contents: "{{ secrets['postgresql']['host'] }}:*:{{ secrets['postgresql']['database'] }}:{{ secrets['postgresql']['user'] }}:{{ secrets['postgresql']['password'] }}"
    - user: {{ config['user'] }}
    - group: {{ config['group'] }}
    - mode: 600
    - require:
      - user: {{ config['user'] }}
      - group: {{ config['group'] }}

{{ config['name'] }}_schema_load:
  cmd.wait:
    - name: 'psql {{ secrets['postgresql']['database'] }} -U {{ secrets['postgresql']['user'] }} -h {{ secrets['postgresql']['host'] }} -f {{ config['path'] }}/src/pkgbase_schema.sql'
    - user: {{ config['user'] }}
    - cwd: {{ config['path'] }}
    - env:
      PGPASSWORD: {{ secrets['postgresql']['password'] }}
    - require:
      - postgres_database: {{ config['name'] }}_postgres_database
      - postgres_user: {{ config['name'] }}_dev_postgres_user
      - cmd: {{ config['name'] }}_postgres_plpgsql
      - cmd: {{ config['name'] }}_postgres_citext
      - hg: {{ config['name'] }}-source
      - file: {{ config['path'] }}/.pgpass
    - watch:
      - postgres_database: {{ config['name'] }}_postgres_database

{{ config['name'] }}_sample_data_load:
  cmd.wait:
    - name: '{{ config['path'] }}/env/bin/python {{ config['path'] }}/src/tools/demodata.py'
    - user: {{ config['user'] }}
    - cwd: {{ config['path'] }}/src
    - require:
      - cmd: {{ config['name'] }}_schema_load
      - virtualenv: {{ config['path'] }}/env
      - file: {{ config['path'] }}/src/config.ini
      - file: {{ config['data_mount'] }}
    - watch:
      - postgres_database: {{ config['name'] }}_postgres_database

{% endfor %}
