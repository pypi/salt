java-1.7.0-openjdk:
  pkg.installed

elasticsearch:
  pkg.installed:
    - sources:
      - elasticsearch: https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.5.2.noarch.rpm
    - require:
      - pkg: java-1.7.0-openjdk
  service.running:
    - require:
      - pkg: elasticsearch
