
pypi-deploy-devpypi:
  name: devpypi
  user: devpypi
  group: devpypi
  user_uid: 6666
  group_gid: 6666

  source_uri: https://bitbucket.org/pypa/pypi
  source_rev: tip

  fastly_syslog_name: pypi-dev
  path: /opt/devpypi
  data_mount: /data/devpypi
  data_device:
    type: local
    uri: None

  server_names:
    - 192.168.57.9
  tls_port: 8999
  docs_port: 8989
  url: https://192.168.57.9

  statuspage_id: 928bjjg42vzc

  rate_limit:
    enable: True
    zone_size: 30m
    max_rate: 5r/s
    burst: 10
    nodelay: False

  cdn_log_archiver:
    pypi_log_bucket: testpypi-cdn-logs
    s3_host: objects.dreamhost.com
    debug: 10
