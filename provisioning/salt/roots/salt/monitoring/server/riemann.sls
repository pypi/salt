
{% set riemann_config = pillar.get('riemann', {}) %}

riemann-pkg:
  pkg.installed:
    - sources:
      - riemann: http://aphyr.com/riemann/riemann-0.2.4-1.noarch.rpm

riemann:
  service:
    - running
    - enable: True
    - reload: True
    - watch:
      - file: /etc/riemann/riemann.config
    - require:
      - pkg: riemann-pkg

/etc/riemann/riemann.config:
  file.managed:
    - source: salt://monitoring/server/config/riemann.config.jinja
    - template: jinja
    - context:
      host: {{ riemann_config.get('host', '0.0.0.0') }}
      graphite_host: {{ riemann_config.get('graphite_host', '0.0.0.0') }}
      graphite_port: {{ riemann_config.get('graphite_port', 2002) }}
      graphite_downstream_host: {{ riemann_config.get('graphite_downstream_host', '127.0.0.1') }}
      graphite_downstream_port: {{ riemann_config.get('graphite_downstream_port', 2003) }}
    - user: 
    - group: riemann
    - require:
      - pkg: riemann-pkg

