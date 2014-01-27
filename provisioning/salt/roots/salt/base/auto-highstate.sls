
15m-interval-highstate:
  cron.present:
    - name: salt-call state.highstate >> /var/log/salt/cron-highstate.log
    - minute: '*/15'

/etc/logrotate.d/salt:
  file.managed:
    - source: salt://base/config/salt-logrotate.conf
