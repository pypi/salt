
datadog_tags:
  - lol:wut
  - tang
  - wu

datadog_dogstreams:
  - /var/log/nginx/pypi/access.log:/usr/share/datadog-nginx-status-codes.py:parse

firewall:
  http:
    port: 80
  https:
    port: 443
  http_dev:
    port: 8999
  http_docs:
    port: 8989
  internal-pypi-port:
    port: 40713
    src: {{ salt['pillar.get']('pypi_internal_network', '127.0.0.0/24') }}
  internal-testpypi-port:
    port: 40714
    src: {{ salt['pillar.get']('pypi_internal_network', '127.0.0.0/24') }}
  internal-docs-port:
    port: 40715
    src: {{ salt['pillar.get']('pypi_internal_network', '127.0.0.0/24') }}
  internal-testdocs-port:
    port: 40716
    src: {{ salt['pillar.get']('pypi_internal_network', '127.0.0.0/24') }}
