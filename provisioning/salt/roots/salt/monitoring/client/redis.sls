
/etc/collectd.d/redis.conf:
  file.managed:
    - source: salt://monitoring/client/config/collectd.d/redis.conf
    - require:
      - file: /usr/local/lib/collectd/plugins
