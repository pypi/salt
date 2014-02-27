warehouse-deploy-devpypi:
  name: devwarehouse
  user: devwarehouse
  group: devwarehouse
  user_uid: 7666
  group_gid: 7666
  path: /opt/devwarehouse

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
    cache:
      browser:
        index: 1
        simple: 1
        packages: 1
        project_detail: 1
        user_profile: 1
      varnish:
        index: 120
        simple: 120
        packages: 120
        project_detail: 120
        user_profile: 120
    security:
      csp:
        default-src:
          - self
          - {{ grains['fqdn'] }}:9000
          - "localhost:9000"
          - "192.168.57.9:9000"
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
