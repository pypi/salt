
jlaska-redis-28-repo-pkg-deps:
  pkg.installed:
    - pkgs:
      - pygpgme
      - yum-utils

/etc/pki/rpm-gpg/RPM-GPG-KEY-jlaska-redis-28:
  file.managed:
    - source: salt://redis/copr/config/jlaska-redis-28.gpgkey
    - user: root
    - group: root
    - mode: 444

jlaska-redis-28:
  pkgrepo.managed:
    - humanname: Copr repo for redis-28 owned by jlaska
    - baseurl: https://copr-be.cloud.fedoraproject.org/results/jlaska/redis-28/epel-6-$basearch/
    - gpgcheck: 1
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-jlaska-redis-28
    - skip_if_unavailable: True
    - sslverify: 1
    - sslcacert: /etc/pki/tls/certs/ca-bundle.crt
    - require:
      - file: /etc/pki/rpm-gpg/RPM-GPG-KEY-jlaska-redis-28
      - pkg: jlaska-redis-28-repo-pkg-deps

