
supervisor-python-pip:
  pkg.installed:
    - name: python-pip

supervisor-python-argparse:
  pkg.installed:
    - name: python-argparse

supervisor-python-psutil:
  pkg.installed:
    - name: python-psutil

supervisor==3.0:
  pip.installed:
    - bin_env: /usr/bin/pip
    - require:
      - pkg: supervisor-python-pip
      - pkg: supervisor-python-psutil
      - pkg: supervisor-python-argparse

/etc/init.d/supervisord:
  file.managed:
    - source: salt://supervisor/config/supervisord.init
    - user: root
    - group: root
    - mode: 744
    - mode: 755
  cmd.wait:
    - name: chkconfig --add supervisord
    - watch:
      - file: /etc/init.d/supervisord

/etc/supervisord.conf:
  file.managed:
    - source: salt://supervisor/config/supervisord.conf
    - user: root
    - group: root
    - mode: 644

/var/log/supervisor:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - mkdirs: True

/etc/supervisord.d:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - mkdirs: True

supervisord:
  service:
    - enable: True
    - running
    - require:
      - pip: supervisor==3.0
      - file: /etc/init.d/supervisord
      - file: /etc/supervisord.conf
      - file: /var/log/supervisor
      - file: /etc/supervisord.d
