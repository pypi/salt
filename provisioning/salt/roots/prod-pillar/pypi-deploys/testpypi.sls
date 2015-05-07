
pypi-deploy-testpypi:
  name: testpypi
  user: testpypi
  group: testpypi
  user_uid: 6666
  group_gid: 6666

  source_uri: https://bitbucket.org/pypa/pypi
  source_rev: default

  fastly_syslog_name: testpypicdn
  path: /opt/testpypi
  site_packages: False
  data_mount: /data/testpypi
  data_device:
    type: glusterfs
    uri: 172.16.57.11:/testpypi

  docs_bucket: pypi-docs-staging
  files_bucket: pypi-files-staging

  server_names:
    - testpypi.python.org
    - testpypi.a.ssl.fastly.net
  tls_port: 9001
  docs_port: 9011
  internal_pypi_port: 40714
  internal_docs_port: 40716
  url: https://testpypi.python.org

  statuspage_id: 928bjjg42vzc

  rate_limit:
    enable: True
    zone_size: 10m
    max_rate: 3r/s
    burst: 6
    nodelay: False

  cdn_log_archiver:
    pypi_log_bucket: testpypi-cdn-logs
    s3_host: objects.dreamhost.com
    debug: true
