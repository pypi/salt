
python27-repo-pkg-deps:
  pkg.installed:
    - pygpgme
    - yum-utils

/etc/pki/rpm-gpg/RPM-GPG-KEY-PYTHON-27:
  file.managed:
    - source: salt://python/27/RPM-GPG-KEY-PYTHON-27
    - user: root
    - group: root
    - mode: 444

python27-el6:
  pkgrepo.managed:
    - humanname: EWDurbin_python-el6
    - baseurl: https://packagecloud.io/EWDurbin/python-el6/el/6/$basearch
    - repo_gpgcheck: 1
    - gpgcheck: 1
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-PYTHON-27
    - sslverify: 1
    - sslcacert: /etc/pki/tls/certs/ca-bundle.crt
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
    - name: 'curl https://bootstrap.pypa.io/get-pip.py | python2.7'
    - watch:
      - pkg: python27
    - require:
      - pkg: python27
