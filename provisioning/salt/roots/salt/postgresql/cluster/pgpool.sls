
include:
  - postgresql.93.repo

postgres:
  user.present

pgpool-II-93:
  pkg:
    - installed
    - require:
      - pkgrepo: pgdg-93-centos
  service:
    - running
    - enable: True
    - reload: True
    - watch:
      - file: /etc/pgpool-II-93/pgpool.conf
    - require:
      - file: /etc/pgpool-II-93/pgpool.conf

/var/log/pgpool-II:
  file.directory:
    - user: postgres
    - group: postgres
    - mode: 750
    - require:
      - user: postgres

/etc/pgpool-II-93/pool_hba.conf:
  file.managed:
    - source: salt://postgresql/cluster/config/pool_hba.conf.jinja
    - template: jinja

/etc/pgpool-II-93/pool_passwd:
  file.managed:
    - source: salt://postgresql/cluster/config/pool_passwd.jinja
    - template: jinja
    - user: postgres
    - group: postgres
    - mode: 640
    - require:
      - user: postgres

/etc/pgpool-II-93/pcp.conf:
  file.managed:
    - source: salt://postgresql/cluster/config/pcp.conf.jinja
    - template: jinja

/etc/pgpool-II-93/pgpool.conf:
  file.managed:
    - source: salt://postgresql/cluster/config/pgpool.conf.jinja
    - template: jinja
    - require:
      - file: /etc/pgpool-II-93/pcp.conf
      - file: /var/log/pgpool-II

{% for pg_user, config in pillar.get('postgresql_users', {}).items() %}

{% set name = config['name'] %}
{% set password = config['password'] %}

{{ pg_user }}_pool_passwd:
  cmd.run:
    - name: 'pg_md5 --md5auth --username={{ name }} {{ password }}'

{% endfor %}
