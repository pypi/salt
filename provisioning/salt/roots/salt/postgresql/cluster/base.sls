postgresql-93-repo:
  pkg.installed:
    - sources:
      - pgdg-centos93: http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/pgdg-centos93-9.3-1.noarch.rpm

postgresql93-server:
  pkg:
    - installed
    - require:
      - pkg: postgresql-93-repo
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
  {% if 'slave' in grains['roles'] %}
    - name: pg_basebackup -h {{ pillar['postgresql_cluster']['primary_server'] }} -D /var/lib/pgsql/9.3/data -U postgres
    - user: postgres
  {% else %}
    - name: service postgresql-9.3 initdb
  {% endif %}
    - watch:
      - pkg: postgresql93-server
