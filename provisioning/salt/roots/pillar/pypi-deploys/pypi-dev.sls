
pypi-deploy-devpypi:
  name: devpypi
  user: devpypi
  group: devpypi
  user_uid: 6666
  group_gid: 6666

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
  url: http://192.168.57.9

  statuspage_id: 928bjjg42vzc
