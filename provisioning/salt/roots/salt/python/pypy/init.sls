
/etc/pki/rpm-gpg/RPM-GPG-KEY-PYTHON-PYPY:
  file.managed:
    - source: salt://python/pypy/RPM-GPG-KEY-PYTHON-PYPY
    - user: root
    - group: root
    - mode: 444

pypy-el6:
  pkgrepo.managed:
    - humanname: Python 2.7 $releasever
    - baseurl: http://ernest.ly/rpms/pypy-el6/$basearch/
    - gpgcheck: 1
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-PYTHON-PYPY
    - require:
      - file: /etc/pki/rpm-gpg/RPM-GPG-KEY-PYTHON-PYPY

pypy:
  pkg.installed:
    - require:
      - pkgrepo: pypy-el6

pypy-virtualenv:
  pkg.installed:
    - require:
      - pkgrepo: pypy-el6
