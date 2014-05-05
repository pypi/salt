
pypi-deploy-pypi:
  name: pypi
  user: pypi
  group: pypi
  user_uid: 7000
  group_gid: 7000

  source_uri: https://bitbucket.org/pypa/pypi
  source_rev: production

  fastly_syslog_name: counterpypicdn
  path: /opt/pypi
  data_mount: /data/pypi
  data_device:
    type: glusterfs
    uri: 172.16.57.11:/pypi

  server_names:
    - pypi.python.org
    - pypi.a.ssl.fastly.net
  tls_port: 9000
  docs_port: 9010
  url: https://pypi.python.org

  statuspage_id: 2p66nmmycsj3

  cdn_log_archiver:
    pypi_log_bucket: pypi-cdn-logs
    s3_host: objects.dreamhost.com
    debug: false
