
secrets-pypi-deploy-devpypi:
  postgresql:
    host: 127.0.0.1
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
    dsn: ''
  fastly:
    api_key: ''
    service_id: ''
  pubkey: |
    -----BEGIN PUBLIC KEY-----
    publiclolnope
    -----END PUBLIC KEY-----
  privkey: |
    -----BEGIN DSA PRIVATE KEY-----
    privatelolnope
    -----END DSA PRIVATE KEY-----
