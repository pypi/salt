
warehouse-deploy-testpypi:
  name: warehouse-testpypi
  user: warehouse-testpypi
  group: warehouse-testpypi
  user_uid: 6666
  group_gid: 6666
  path: /opt/warehouse-testpypi

  port: 9000

  secrets_key: secrets-warehouse-testpypi

  source_uri: https://github.com/pypa/warehouse.git
  source_rev: master
