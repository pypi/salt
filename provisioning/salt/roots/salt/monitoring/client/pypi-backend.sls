
/etc/collectd.d/pypi-backend.conf:
  file.managed:
    - source: salt://monitoring/client/config/collectd.d/pypi-backend.conf
    - require:
      - file: /usr/local/lib/collectd/plugins
