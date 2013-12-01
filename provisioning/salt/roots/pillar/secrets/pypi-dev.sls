
secrets-pypi-deploy-devpypi:
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
