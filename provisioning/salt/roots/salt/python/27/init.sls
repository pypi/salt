
/etc/pki/rpm-gpg/RPM-GPG-KEY-PYTHON-27:
  file.managed:
    - source: salt://python/27/RPM-GPG-KEY-PYTHON-27
    - user: root
    - group: root
    - mode: 444

python27-el6:
  pkgrepo.managed:
    - humanname: Python 2.7 $releasever
    - baseurl: http://ernest.ly/rpms/python27-el6/$basearch/
    - gpgcheck: 1
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-PYTHON-27
    - require:
      - file: /etc/pki/rpm-gpg/RPM-GPG-KEY-PYTHON-27

python27:
  pkg.installed:
    - require:
      - pkgrepo: python27-el6

setuptools-2.7:
  cmd.wait:
    - name: 'curl https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py | python2.7'
    - watch:
      - pkg: python27
    - require:
      - pkg: python27

pip-2.7:
  cmd.wait:
    - name: 'curl https://raw.github.com/pypa/pip/master/contrib/get-pip.py | python2.7'
    - watch:
      - pkg: python27
    - require:
      - pkg: python27
