
/etc/pki/rpm-gpg/RPM-GPG-KEY-NGINX:
  file.managed:
    - source: salt://nginx/config/RPM-GPG-KEY-NGINX
    - user: root
    - group: root
    - mode: 444

nginx-release:
  pkgrepo.managed:
    - humanname: nginx CentOS YUM repository
    - baseurl: http://nginx.org/packages/centos/$releasever/$basearch/
    - gpgcheck: 1
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-NGINX
    - require:
      - file: /etc/pki/rpm-gpg/RPM-GPG-KEY-NGINX

nginx:
  user.present:
    - system: True
    - shell: /sbin/nologin
    - groups:
      - nginx
    - require:
      - group: nginx
  group.present:
    - system: True
  pkg:
    - installed
    - require:
      - pkgrepo: nginx-release
  service:
    - running
    - enable: True
    - reload: True
    - watch:
      - file: /etc/nginx/nginx.conf
      - file: /etc/nginx/nginx.ssl.conf
      - file: /etc/nginx/conf.d/*
    - require:
      - file: /etc/nginx/nginx.conf
      - pkg: nginx
      - user: nginx

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://nginx/config/nginx.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /var/log/nginx

/etc/nginx/nginx.ssl.conf:
  file.managed:
    - source: salt://nginx/config/nginx.ssl.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - module: self-signed-cert

/etc/logrotate.d/nginx:
  file.managed:
    - source: salt://nginx/config/nginx.logrotate
    - user: root
    - group: root
    - mode: 644

/var/log/nginx:
  file.directory:
    - user: nginx
    - group: root
    - mode: 0750

/etc/nginx/conf.d/default.conf:
  file.absent

/etc/nginx/conf.d/virtual.conf:
  file.absent

/etc/nginx/conf.d/ssl.conf:
  file.absent

lego_extract:
  archive.extracted:
    - name: /usr/local/bin/
    - if_missing: /usr/local/bin/lego
    - source: https://github.com/xenolf/lego/releases/download/v0.3.1/lego_linux_amd64.tar.xz
    - source_hash: sha256=cee9511099e9864968ac9c68f2f8d77fd927cda17957546d99faaf93f310538a
    - archive_format: tar
    - tar_options: -J --strip-components=1 lego/lego

/etc/lego:
  file.directory:
    - user: root
    - group: root
    - mode: 0755

/etc/lego/.well-known/acme-challenge:
  file.directory:
    - user: nginx
    - group: root
    - mode: 0750
    - makedirs: True
    - require:
      - file: /etc/lego

lego_bootstrap:
  cmd.run:
    - name: /usr/local/bin/lego -a --email="infrastructure-staff@python.org" --domains="{{ grains['fqdn'] }}" --webroot /etc/lego --path /etc/lego run
    - creates: /etc/lego/certificates/{{ grains['fqdn'] }}.json
    - require:
      - file: /etc/lego/.well-known/acme-challenge
      - archive: lego_extract

lego_renew:
  cron.present:
    - name: /usr/local/bin/lego -a --email="infrastructure-staff@python.org" --domains="{{ grains['fqdn'] }}" --webroot /etc/lego --path /etc/lego renew --days 30
    - hour: 0
    - minute: random
