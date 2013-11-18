
include:
  - python.27.virtualenv
  - python.27.m2crypto
  - pkg.hg
  - nginx
  - redis
{% if 'develop' in grains['roles'] %}
  - postgresql.93
  - pypi.dev-db
{% endif %}

pypi:
  user.present:
    - home: /opt/pypi

/opt/pypi:
  file.directory:
    - user: pypi
    - group: pypi
    - mode: 755

/var/log/pypi:
  file.directory:
    - user: pypi
    - group: pypi
    - mode: 750

/var/run/pypi:
  file.directory:
    - user: pypi
    - group: pypi
    - mode: 755

/data:
  file.directory:
    - user: root
    - group: root
    - mode: 755

/data/pypi:
  file.directory:
    - user: pypi
    - group: pypi
    - mode: 755
    - require:
      - file: /data
      - user: pypi

/data/pypi/secret:
  file.directory:
    - user: pypi
    - group: pypi
    - mode: 750
    - require:
      - file: /data/pypi
      - user: pypi

/var/log/nginx/pypi:
  file.directory:
    - user: root
    - group: root

/etc/nginx/conf.d/pypi.conf:
  file.managed:
    - source: salt://pypi/config/pypi.nginx.conf.jinja
    - user: root
    - group: root
    - mode: 640
    - require:
      - file: /var/log/nginx/pypi

/etc/logrotate.d/pypi:
  file.managed:
    - source: salt://pypi/config/pypi.logrotate.conf
    - user: root
    - group: root
    - mode: 644

pypi-source:
  hg.latest:
    - name: https://bitbucket.org/pypa/pypi
    - rev: tip
    - target: /opt/pypi/src
    - user: pypi
    - require:
      - user: pypi
      - file: /opt/pypi

pypi-system-deps:
  pkg.installed:
    - pkgs:
      - python27-devel
      - postgresql-devel
      - gcc
    - require:
      - pkgrepo: python27-el6

/opt/pypi/env:
  virtualenv.managed:
    - venv_bin: virtualenv-2.7
    - python: python2.7
    - system_site_packages: True
    - user: pypi
    - cwd: /opt/pypi/src
    - requirements: /opt/pypi/src/requirements.txt
    - require:
      - file: /opt/pypi
      - hg: pypi-source
      - user: pypi
      - pip: virtualenv-2.7
      - pkg: python27-m2crypto
      - pkg: pypi-system-deps

/opt/pypi/src/config.ini:
  file.managed:
    - source: salt://pypi/config/pypi.ini.jinja
    - user: pypi
    - group: pypi
    - mode: 640
    - template: jinja
    - require:
      - file: /var/log/pypi
      - file: /var/run/pypi
      - virtualenv: /opt/pypi/env

/etc/init.d/pypi:
  file.managed:
    - source: salt://pypi/config/pypi.initd.jinja
    - user: root
    - group: root
    - mode: 755
    - template: jinja
    - require:
      - file: /opt/pypi/src/config.ini

pypi-service:
  service:
    - name: pypi
    - running
    - enable: True
    - require:
      - file: /etc/init.d/pypi
