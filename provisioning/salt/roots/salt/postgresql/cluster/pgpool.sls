
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

/home/postgres/bin:
  file.directory:
    - user: postgres
    - group: postgres
    - require:
      - user: postgres

arping-bin:
  file.copy:
    - name: /home/postgres/bin/arping
    - source: /sbin/arping
    - require:
      - file: /home/postgres/bin

/home/postgres/bin/arping:
  file.managed:
    - user: root
    - mode: 4755
    - require:
      - file: arping-bin

ifconfig-bin:
  file.copy:
    - name: /home/postgres/bin/ifconfig
    - source: /sbin/ifconfig
    - require:
      - file: /home/postgres/bin

/home/postgres/bin/ifconfig:
  file.managed:
    - user: root
    - mode: 4755
    - require:
      - file: ifconfig-bin

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
    - user: postgres
    - mode: 740
    - require:
      - file: /etc/pgpool-II-93/pcp.conf
      - file: /var/log/pgpool-II
      - file: /home/postgres/bin/ifconfig
      - file: /home/postgres/bin/arping

{% for pg_user, config in pillar.get('postgresql_users', {}).items() %}

{% set name = config['name'] %}
{% set password = config['password'] %}

{{ pg_user }}_pool_passwd:
  cmd.run:
    - name: 'pg_md5 --md5auth --username={{ name }} {{ password }}'

{% endfor %}
