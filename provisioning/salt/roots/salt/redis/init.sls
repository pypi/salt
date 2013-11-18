
redis:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - require:
      - pkg: redis
  
