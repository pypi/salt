
pypi-deploy-testpypi:
  name: testpypi
  user: testpypi
  group: testpypi
  user_uid: 6666
  group_gid: 6666

  path: /opt/testpypi
  data_mount: /data/testpypi
  data_device:
    type: glusterfs
    uri: 172.16.57.6:/testpypi

  mailhost: localhost:25

  https_only: True
  server_names:
    - testpypi.python.org
    - testpypi.a.ssl.fastly.net
  url: https://testpypi.python.org

  uwsgi:
    processes: 2
