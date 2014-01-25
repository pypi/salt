
pypi-deploy-testpypi:
  name: testpypi
  user: testpypi
  group: testpypi
  user_uid: 6666
  group_gid: 6666

  fastly_syslog_name: pypi-test
  path: /opt/testpypi
  data_mount: /data/testpypi
  data_device:
    type: glusterfs
    uri: 172.16.57.30:/testpypi

  https_only: True
  server_names:
    - testpypi.python.org
  tls_port: 9001
  url: https://testpypi.python.org

  statuspage_id: 928bjjg42vzc
