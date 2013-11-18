
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
    - source: salt://nginx/config/nginx.conf
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

pyOpenSSL:
  pkg:
    - installed

self-signed-cert:
  module.run:
    - name: tls.create_self_signed_cert
    - CN: {{grains['host']}}
    - require:
      - pkg: pyOpenSSL
