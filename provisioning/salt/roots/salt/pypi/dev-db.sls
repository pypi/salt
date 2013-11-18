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

pypi_dev_postgres_user:
  postgres_user.present:
    - name: pypi
    - password: pypi
    - user: postgres
    - require:
      - service: postgresql-9.3
      - pkg: postgresql

pypi_postgres_database:
  postgres_database.present:
    - name: pypi
    - owner: pypi
    - require:
      - postgres_user: pypi_dev_postgres_user

pypi_postgres_citext:
  cmd.wait:
    - name: 'psql pypi -c "CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;"'
    - user: postgres
    - require:
      - postgres_database: pypi_postgres_database
      - postgres_user: pypi_dev_postgres_user
      - pkg: pypi_postgres_contrib
    - watch:
      - postgres_database: pypi_postgres_database
      - postgres_user: pypi_dev_postgres_user
      - pkg: pypi_postgres_contrib

pypi_postgres_plpgsql:
  cmd.wait:
    - name: 'psql pypi -c "CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;"'
    - query: 'CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;'
    - user: postgres
    - require:
      - postgres_database: pypi_postgres_database
      - postgres_user: pypi_dev_postgres_user
    - watch:
      - postgres_database: pypi_postgres_database
      - postgres_user: pypi_dev_postgres_user

pypi_schema_load:
  cmd.wait:
    - name: 'psql pypi -f /opt/pypi/src/pkgbase_schema.sql'
    - user: pypi
    - cwd: /opt/pypi/src
    - require:
      - postgres_database: pypi_postgres_database
      - postgres_user: pypi_dev_postgres_user
      - cmd: pypi_postgres_plpgsql
      - cmd: pypi_postgres_citext
      - hg: pypi-source
    - watch:
      - postgres_database: pypi_postgres_database

pypi_sample_data_load:
  cmd.wait:
    - name: '/opt/pypi/env/bin/python /opt/pypi/src/tools/demodata.py'
    - user: pypi
    - cwd: /opt/pypi/src
    - require:
      - cmd: pypi_schema_load
      - virtualenv: /opt/pypi/env
      - file: /opt/pypi/src/config.ini
    - watch:
      - postgres_database: pypi_postgres_database
