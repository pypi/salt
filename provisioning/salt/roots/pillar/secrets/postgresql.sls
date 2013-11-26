
postgresql_users:
  pypi:
    name: pypi
    password: pypi
  testpypi:
    name: testpypi
    password: testpypi

postgresql_databases:
  pypi:
    name: pypi
    owner: pypi
  testpypi:
    name: testpypi
    owner: testpypi

postgresql_extensions:
  pypi_plpgsql:
    name: plpgsql
    database: pypi
  pypi_citext:
    name: citext
    database: pypi
  testpypi_plpgsql:
    name: plpgsql
    database: testpypi
  testpypi_citext:
    name: citext
    database: testpypi
