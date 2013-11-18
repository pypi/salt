
include:
  - python.27

system-pip:
  pkg.installed:
    - name: python-pip

virtualenv-2.7:
  pip.installed:
    - name: virtualenv
    - pip_bin: pip-2.7
    - require:
      - pkg: system-pip
      - pkg: python27
      - cmd: pip-2.7
