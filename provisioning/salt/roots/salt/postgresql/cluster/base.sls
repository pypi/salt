
include:
  - postgresql.93.repo

postgresql93-server:
  pkg:
    - installed
    - require:
      - pkgrepo: pgdg-93-centos
  service:
    - name: postgresql-9.3
    - running
    - enable: True
    - reload: True
    - watch:
      - file: /var/lib/pgsql/9.3/data/pg_hba.conf
      - file: /var/lib/pgsql/9.3/data/postgresql.conf
    - require:
      - pkg: postgresql93-server
  cmd.wait:
  {% if 'standby' in grains['roles'] %}
    - name: pg_basebackup -h {{ pillar['postgresql_cluster']['primary_server'] }} -D /var/lib/pgsql/9.3/data -U postgres
    - user: postgres
  {% else %}
    - name: service postgresql-9.3 initdb
  {% endif %}
    - watch:
      - pkg: postgresql93-server

pypi_postgres_contrib:
  pkg.installed:
    - name: postgresql93-contrib
