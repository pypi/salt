
firewall:
  http:
    port: 80
  https:
    port: 443

bandersnatch:
  mirror:
    directory: /data/pypi-mirror
    master: https://pypi.python.org
    timeout: 10
    workers: 20
    stop-on-error: false
    delete-packages: true
  statistics:
    access-log-pattern: /var/log/nginx/pypi-mirror/access*.log
  server_names:
    - mirror0.pypi.io
