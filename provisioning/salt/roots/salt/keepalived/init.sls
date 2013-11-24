net.ipv4.ip_forward:
  sysctl.present:
    - value: 1

/etc/keepalived/keepalived.conf:
  file.managed:
    - source: salt://keepalived/config/keepalived.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 640

keepalived:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - reload: True
    - watch:
      - file: /etc/keepalived/keepalived.conf
    - require:
      - file: /etc/keepalived/keepalived.conf
      - sysctl: net.ipv4.ip_forward
