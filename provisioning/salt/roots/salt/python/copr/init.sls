
ewdurbin-pythons-el6-repo-pkg-deps:
  pkg.installed:
    - pkgs:
      - pygpgme
      - yum-utils

/etc/pki/rpm-gpg/RPM-GPG-KEY-ewdurbin-pythons-el6:
  file.managed:
    - source: salt://python/copr/config/ewdurbin-pythons-el6.gpgkey
    - user: root
    - group: root
    - mode: 444

ewdurbin-pythons-el6:
  pkgrepo.managed:
    - humanname: Copr repo for pythons-el6 owned by ewdurbin
    - baseurl: https://copr-be.cloud.fedoraproject.org/results/ewdurbin/pythons-el6/epel-6-$basearch/
    - repo_gpgcheck: 1
    - gpgcheck: 1
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ewdurbin-pythons-el6
    - skip_if_unavailable: 1
    - sslverify: 1
    - sslcacert: /etc/pki/tls/certs/ca-bundle.crt
    - require:
      - file: /etc/pki/rpm-gpg/RPM-GPG-KEY-ewdurbin-pythons-el6
      - pkg: ewdurbin-pythons-el6-repo-pkg-deps
