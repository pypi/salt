java-1.7.0-openjdk:
  pkg.installed

elasticsearch:
  pkg.installed:
    - sources:
      - elasticsearch: https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.0.0.noarch.rpm
    - require:
      - pkg: java-1.7.0-openjdk
  service.running:
    - require:
      - pkg: elasticsearch
