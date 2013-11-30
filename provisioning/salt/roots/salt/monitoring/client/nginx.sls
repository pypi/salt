
/etc/collectd.d/nginx.conf:
  file.managed:
    - source: salt://monitoring/client/config/collectd.d/nginx.conf

collectd-nginx:
  pkg:
    - installed
