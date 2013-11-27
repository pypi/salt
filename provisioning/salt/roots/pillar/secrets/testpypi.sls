
secrets-pypi-deploy-testpypi:
  postgresql:
    host: 172.16.57.100
    database: testpypi
    user: testpypi
    password: testpypi
  webui:
    cheescake_password: secret
    reset_secret: secret
  logging:
    mailhost: mail.python.org
    fromaddr: foo@bar.com
    toaddrs: fiz@bar.com
  sentry:
    dsn: deadbeef
  fastly:
    api_key: deadbeef
    service_id: deadbeef
