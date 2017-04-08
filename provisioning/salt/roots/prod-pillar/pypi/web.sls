
firewall:
  http:
    port: 80
  https:
    port: 443
  pypi-port:
    port: 9000
  testpypi-port:
    port: 9001
  pythonhosted-port:
    port: 9010
  test-pythonhosted-port:
    port: 9011
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
