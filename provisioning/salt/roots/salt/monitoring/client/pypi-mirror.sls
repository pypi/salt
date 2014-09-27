
/etc/collectd.d/pypi-mirror.conf:
  file.managed:
    - source: salt://monitoring/client/config/collectd.d/pypi-mirror.conf
    - require:
      - file: /usr/local/lib/collectd/plugins
