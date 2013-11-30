
{% set carbon_config = pillar.get('carbon', {}) %}
{% set graphite_config = pillar.get('graphite', {}) %}

graphite-pkgs:
  pkg.installed:
    - pkgs:
      - graphite-web
      - python-carbon
      - httpd

/etc/carbon/carbon.conf:
  file.managed:
    - source: salt://monitoring/server/config/carbon.conf.jinja
    - template: jinja
    - context:
      line_receiver_interface: {{ carbon_config.get('line_receiver_interface', '0.0.0.0') }}
      line_reciver_port: {{ carbon_config.get('line_reciver_port', 2003) }}
      pickle_receiver_interface: {{ carbon_config.get('pickle_receiver_interface', '0.0.0.0') }}
      pickle_receiver_port: {{ carbon_config.get('pickle_receiver_port', 2004) }}
      cache_query_interface: {{ carbon_config.get('cache_query_interface', '0.0.0.0') }}
      cache_query_port: {{ carbon_config.get('cache_query_port', 7002) }}

/etc/carbon/storage-schemas.conf:
  file.managed:
    - source: salt://monitoring/server/config/storage-schemas.conf.jinja
    - template: jinja

carbon-cache:
  service:
    - running
    - enable: True
    - restart: True
    - watch:
      - file: /etc/carbon/carbon.conf
      - file: /etc/carbon/storage-schemas.conf
    - require:
      - file: /etc/carbon/carbon.conf
      - file: /etc/carbon/storage-schemas.conf
