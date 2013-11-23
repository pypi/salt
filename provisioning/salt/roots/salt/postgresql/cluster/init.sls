
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

{% if not salt['file.file_exists']('/var/lib/pgsql/9.3/data/recovery.conf')
  and not salt['file.file_exists']('/var/lib/pgsql/9.3/data/recovery.done')
  and 'slave' in grains['roles'] %}
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
{% endif %}

restart_postgresql:
  cmd.wait:
    - name: service postgresql-9.3 restart
    - watch:
      - file: /var/lib/pgsql/9.3/data/postgresql.conf
      - file: /var/lib/pgsql/9.3/data/recovery.conf

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

/var/lib/pgsql/bin:
  file.directory:
    - user: postgres
    - group: postgres
    - mode: 750

/var/lib/pgsql/bin/base-backup.bash:
  file.managed:
    - source: salt://postgresql/cluster/config/base-backup.bash
    - user: postgres
    - group: postgres
    - mode: 750
    - require:
      - file: /var/lib/pgsql/bin
