
include:
  - python.27

python27-m2crypto:
  pkg.installed:
    - require:
      - pkgrepo: python27-el6 
