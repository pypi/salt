
secrets-pypi-deploy-devpypi:
  database_url: postgresql://testpypi:testpypi@localhost/testpypi
  database_download_statistics_url: postgresql://testpypi:testpypi@localhost/testpypi
  elasticsearch:
    host: localhost
    port: 9200
  postgresql:
    host: 127.0.0.1
    database: testpypi
    user: testpypi
    password: testpypi
  redis:
    queue_redis_url: redis://localhost:6379/0
    count_redis_url: redis://localhost:6379/1
  webui:
    cheescake_password: secret
    reset_secret: secret
  logging:
    fromaddr: foo@bar.com
    toaddrs: fiz@bar.com
  sentry:
    dsn: ''
  fastly:
    api_key: ''
    service_id: ''
  uwsgi:
    processes: 2
  smtp:
    hostname: localhost
    starttls: 'off'
    auth: 'off'
    login: None
    password: None
  pubkey: |
    -----BEGIN PUBLIC KEY-----
    publiclolnope
    -----END PUBLIC KEY-----
  privkey: |
    -----BEGIN DSA PRIVATE KEY-----
    privatelolnope
    -----END DSA PRIVATE KEY-----
  cdn_log_archiver:
    secret_key: lmsecretao
    access_key: accesslol
