
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
    - require:
      - pkg: postgresql93-server
  cmd.wait:
    - name: service postgresql-9.3 initdb
    - watch:
      - pkg: postgresql93-server
