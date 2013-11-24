
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
