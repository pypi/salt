
include:
  - python.copr

python27:
  pkg.installed:
    - require:
      - pkgrepo: ewdurbin-pythons-el6

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
