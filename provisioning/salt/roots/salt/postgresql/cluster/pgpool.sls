pgpool-postgresql-93-repo:
  pkg.installed:
    - sources:
      - pgdg-centos93: http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/pgdg-centos93-9.3-1.noarch.rpm

postgres:
  user.present

pgpool-II-93:
  pkg:
    - installed
    - require:
      - pkg: pgpool-postgresql-93-repo
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
