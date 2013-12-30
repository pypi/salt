/etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG-93:
  file.managed:
    - source: salt://postgresql/93/RPM-GPG-KEY-PGDG-93
    - user: root
    - group: root
    - mode: 444

pgdg-93-centos:
  pkgrepo.managed:
    - humanname: PostgreSQL 9.3 $releasever - $basearch
    - baseurl: http://yum.postgresql.org/9.3/redhat/rhel-$releasever-$basearch
    - gpgcheck: 1
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG-93
    - require:
      - file: /etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG-93
