{% if grains['os'] == 'CentOS' %}
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
{% endif %}

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
    {% if grains['os'] == 'CentOS' %}
    - require:
      - pkgrepo: nginx-release
    {% endif %}
  service:
    - running
    - enable: True
    - reload: True
    - watch:
      - file: /etc/nginx/nginx.conf
      {% if grains['os'] == 'CentOS' %}
      - file: /etc/nginx/nginx.ssl.conf
      {% endif %}
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

{% if grains['os'] == 'CentOS' %}
/etc/nginx/nginx.ssl.conf:
  file.managed:
    - source: salt://nginx/config/nginx.ssl.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - module: self-signed-cert
{% endif %}

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

{% if grains['os'] == 'CentOS' %}
pyOpenSSL:
  pkg:
    - installed

self-signed-cert:
  module.run:
    - name: tls.create_self_signed_cert
    - CN: {{ grains['fqdn'] }}
    - require:
      - pkg: pyOpenSSL
{% endif %}
