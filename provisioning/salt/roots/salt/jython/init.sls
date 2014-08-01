include:
  - nginx

/etc/nginx/conf.d/jython.conf:
  file.managed:
    - source: salt://jython/config/jython.nginx.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 640

jython:
  group.present
