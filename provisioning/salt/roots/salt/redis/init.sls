
include:
  - redis.copr

redis28:
  pkg:
    - installed

redis:
  service:
    - running
    - enable: True
    - require:
      - pkg: redis28
  
{% if 'datadog_api_key' in pillar %}
/etc/dd-agent/conf.d/redisdb.yaml:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        init_config:
        instances:
            - host: localhost
              port: 6379
{% endif %}
