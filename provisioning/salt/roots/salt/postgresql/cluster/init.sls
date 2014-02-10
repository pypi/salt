
include:
  - postgresql.cluster.base

/var/lib/pgsql/9.3/data/postgresql.conf:
  file.managed:
    - name: /var/lib/pgsql/9.3/data/postgresql.conf
    - source: salt://postgresql/cluster/config/postgresql.conf.jinja
    - template: jinja
    - user: postgres
    - group: postgres
    - mode: 600
    - require:
      - pkg: postgresql93-server
      - cmd: postgresql93-server

{% if 'standby' in grains['roles'] %}
/var/lib/pgsql/9.3/data/recovery.conf:
  file.managed:
    - name: /var/lib/pgsql/9.3/data/recovery.conf
    - source: salt://postgresql/cluster/config/recovery.conf.jinja
    - template: jinja
    - user: postgres
    - group: postgres
    - mode: 600
    - require:
      - pkg: postgresql93-server
      - cmd: postgresql93-server
{% else %}
/var/lib/pgsql/9.3/data/recovery.conf:
  file.absent
{% endif %}

restart_postgresql:
  cmd.wait:
    - name: service postgresql-9.3 restart
    - watch:
      - file: /var/lib/pgsql/9.3/data/postgresql.conf
{% if 'standby' in grains['roles'] %}
      - file: /var/lib/pgsql/9.3/data/recovery.conf
{% endif %}

/var/lib/pgsql/9.3/data/pg_hba.conf:
  file.managed:
    - name: /var/lib/pgsql/9.3/data/pg_hba.conf
    - source: salt://postgresql/cluster/config/pg_hba.conf.jinja
    - template: jinja
    - user: postgres
    - group: postgres
    - mode: 600
    - require:
      - pkg: postgresql93-server
      - cmd: postgresql93-server

{% if 'primary' in grains['roles'] %}

/var/lib/pgsql/9.3/backups/base:
  file.directory:
    - user: postgres
    - group: postgres
    - service: postgresql-9.3
    - pkg: postgresql93-server

/var/lib/pgsql/9.3/backups/archives:
  file.directory:
    - user: postgres
    - group: postgres
    - service: postgresql-9.3
    - pkg: postgresql93-server

  {% for pg_user, config in pillar.get('postgresql_users', []).items() %}

  {% set name = config['name'] %}
  {% set password = config['password'] %}

{{ pg_user }}_postgres_user:
  postgres_user.present:
    - name: {{ name }}
    - password: {{ password }}
    - user: postgres
    - require:
      - service: postgresql-9.3
      - pkg: postgresql93-server
  {% endfor %}

  {% for pg_database, config in pillar.get('postgresql_databases', []).items() %}

  {% set name = config['name'] %}
  {% set owner = config.get('owner', 'postgres') %}

{{ pg_database }}_postgres_database:
  postgres_database.present:
    - name: {{ name }}
    - owner: {{ owner }}
     {% if config.get('owner', False) %}
    - require:
      - postgres_user: {{ owner }}
     {% endif %}
 
  {% endfor %}

{% if salt['pillar.get']('postgresql_cluster:postgresql:pg_stat_statements', False) %}
  cmd.wait:
    - name: 'psql postgres -c "CREATE EXTENSION IF NOT EXISTS pg_stat_statements;"'
    - user: postgres
    - require:
      - file: /var/lib/pgsql/9.3/data/postgresql.conf
      - pkg: pypi_postgres_contrib
    - watch:
      - file: /var/lib/pgsql/9.3/data/postgresql.conf
      - pkg: pypi_postgres_contrib
{% endif %}

  {% for pg_extension, config in pillar.get('postgresql_extensions', []).items() %}

  {% set ext = config['name'] %}
  {% set database = config['database'] %}
  {% set schema = config.get('schema', 'public') %}

{{ database }}_{{ schema }}_postgres_extension_{{ ext }}:
  cmd.wait:
    - name: 'psql {{ database }} -c "CREATE EXTENSION IF NOT EXISTS {{ ext }} WITH SCHEMA {{ schema }};"'
    - user: postgres
    - require:
      - postgres_database: {{ database }}_postgres_database
      - pkg: pypi_postgres_contrib
    - watch:
      - postgres_database: {{ database }}_postgres_database
      - pkg: pypi_postgres_contrib

  {% endfor %}

{% endif %}
