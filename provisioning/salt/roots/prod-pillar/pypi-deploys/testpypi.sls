
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
  data_mount: /data/testpypi
  data_device:
    type: glusterfs
    uri: 172.16.57.6:/testpypi

  server_names:
    - testpypi.python.org
    - testpypi.a.ssl.fastly.net
  tls_port: 9001
  docs_port: 9011
  url: https://testpypi.python.org

  statuspage_id: 928bjjg42vzc
