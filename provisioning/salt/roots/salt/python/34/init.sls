
/etc/pki/rpm-gpg/RPM-GPG-KEY-PYTHON-34:
  file.managed:
    - source: salt://python/34/RPM-GPG-KEY-PYTHON-34
    - user: root
    - group: root
    - mode: 444

python34-el6:
  pkgrepo.managed:
    - humanname: Python 2.7 $releasever
    - baseurl: http://ernest.ly/rpms/python34-el6/$basearch/
    - gpgcheck: 1
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-PYTHON-34
    - require:
      - file: /etc/pki/rpm-gpg/RPM-GPG-KEY-PYTHON-34

python34-devel:
  pkg.installed:
    - require:
      - pkgrepo: python34-el6
