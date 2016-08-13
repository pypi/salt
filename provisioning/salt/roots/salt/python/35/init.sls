include:
  - python.copr

python35-devel:
  pkg.installed:
    - require:
      - pkgrepo: ewdurbin-pythons-el6
