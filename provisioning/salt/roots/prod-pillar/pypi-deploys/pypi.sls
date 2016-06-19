
pypi-deploy-pypi:
  name: pypi
  user: pypi
  group: pypi
  user_uid: 7000
  group_gid: 7000

  source_uri: https://github.com/pypa/pypi-legacy.git
  source_rev: production

  fastly_syslog_name: counterpypicdn
  path: /opt/pypi
  site_packages: False
  data_mount: /data/pypi
  data_device:
    type: local
    uri: None

  docs_bucket: pypi-docs
  files_bucket: pypi-files

  server_names:
    - pypi.python.org
    - pypi.a.ssl.fastly.net
  tls_port: 9000
  docs_port: 9010
  internal_pypi_port: 40713
  internal_docs_port: 40715
  url: https://pypi.python.org

  statuspage_id: 2p66nmmycsj3

  cdn_log_archiver:
    pypi_log_bucket: pypi-cdn-logs
    s3_host: objects.dreamhost.com
    debug: false
