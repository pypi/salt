
warehouse-deploy-pypi:
  name: warehouse-pypi
  user: warehouse-pypi
  group: warehouse-pypi
  user_uid: 7000
  group_gid: 7000
  path: /opt/warehouse-pypi

  port: 9001

  secrets_key: secrets-warehouse-pypi

  source_uri: https://github.com/pypa/warehouse.git
  source_rev: werkzeug
