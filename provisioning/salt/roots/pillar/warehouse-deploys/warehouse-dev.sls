warehouse-deploy-devpypi:
  name: devwarehouse
  user: devwarehouse
  group: devwarehouse
  user_uid: 7666
  group_gid: 7666
  path: /opt/devwarehouse

  port: 9000

  source_uri: https://github.com/pypa/warehouse.git
  source_rev: master
  
  config:
    debug: true
    site:
      name: Warehouse (dev)
    assets:
      directory: "data/static"
    database:
      url: "{{ salt['pillar.get']('secrets-pypi-deploy-devpypi:database_url', "postgresql://testpypi:testpypi@localhost/testpypi") }}"
      download_statistics_url: "{{ salt['pillar.get']('secrets-pypi-deploy-devpypi:database_download_statistics_url', "postgresql://testpypi:testpypi@localhost/testpypi") }}"
    redis:
      url: "{{ salt['pillar.get']('secrets-pypi-deploy-devpypi:redis:count_redis_url', "redis://localhost:6379/1") }}"
    search:
      hosts:
        - host: {{ salt['pillar.get']('secrets-pypi-deploy-devpypi:elasticsearch:host', "127.0.0.1") }}
          port: {{ salt['pillar.get']('secrets-pypi-deploy-devpypi:elasticsearch:port', "9200") }}
    paths:
      documentation: "/data/devpypi/packagedocs"
      packages: "/data/devpypi/packages"
    urls:
      documentation: "http://pythonhosted.org/"
    security:
      csp:
        default-src:
          - "'self'"
        style-src:
          - "'self'"
          - cloud.typography.com
        font-src:
          - "'self'"
          - "data:"
    logging:
      formatters:
        console:
          format: '[%(asctime)s %(levelname)s] %(message)s'
          datefmt: '%Y-%m-%d %H:%M:%S'
      handlers:
        console:
          class: logging.StreamHandler
          formatter: console
          level: DEBUG
          stream: ext://sys.stdout
      loggers:
        warehouse:
          level: DEBUG
        elasticsearch:
          level: DEBUG
        elasticsearch.trace:
          level: DEBUG
      root:
        level: INFO
        handlers: [console]
