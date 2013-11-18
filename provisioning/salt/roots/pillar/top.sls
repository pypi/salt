base:
  'roles:pypi-mirror':
    - match: grain
    - pypi-mirror
  'roles:pypi':
    - match: grain
    - pypi
