base:
  '*':
    - base.sanity
  'roles:pypi-mirror':
    - match: grain
    - pypi-mirror
