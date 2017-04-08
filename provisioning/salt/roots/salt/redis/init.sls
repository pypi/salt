
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
  
