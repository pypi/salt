
backup-server:
  volumes:
    /dev/xvdb: /backup
  backups:
    testpypi-packages:
      directory: /backup/testpypi/packages
      user: testpypi
      increment_retention: 7D
      authorized_key: ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAzAygdki5c3mszRXLv5fZmAkcDg6sFOjKt2TROCqC6KjAR0kX/lASYfj47yavmC5AZM+AM10T7LuwDgItUnrtqr1awEuseLgP5LX1BO5RHQI8oDsFfA+EcIkvExVh19Y2BE1wdxpCw2aSHMvkpxpTq7VoOlIydLNgPfLegaySfxTm0L8OEAXkLDYH3f8b1+UjGLs0qgt4pwxEYF+mSIAHqPNJ/ynWoMswryA+oCuuqB8723wmGlQhmjeQttYjiqdDda6Z9b9Vsuvhl9rskyLjwwUk0A5XosMdkZwaYNTrQiZ5bl/59Z2/dFRCOSrERPKdaC+hlaLBdoCTE6ASSn6TQQ==
    testpypi-packagedocs:
      directory: /backup/testpypi/packagedocs
      user: testpypi
      increment_retention: 7D
      authorized_key: ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAzAygdki5c3mszRXLv5fZmAkcDg6sFOjKt2TROCqC6KjAR0kX/lASYfj47yavmC5AZM+AM10T7LuwDgItUnrtqr1awEuseLgP5LX1BO5RHQI8oDsFfA+EcIkvExVh19Y2BE1wdxpCw2aSHMvkpxpTq7VoOlIydLNgPfLegaySfxTm0L8OEAXkLDYH3f8b1+UjGLs0qgt4pwxEYF+mSIAHqPNJ/ynWoMswryA+oCuuqB8723wmGlQhmjeQttYjiqdDda6Z9b9Vsuvhl9rskyLjwwUk0A5XosMdkZwaYNTrQiZ5bl/59Z2/dFRCOSrERPKdaC+hlaLBdoCTE6ASSn6TQQ==
    pypi-packages:
      directory: /backup/pypi/packages
      user: pypi
      increment_retention: 7D
      authorized_key: ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAzAygdki5c3mszRXLv5fZmAkcDg6sFOjKt2TROCqC6KjAR0kX/lASYfj47yavmC5AZM+AM10T7LuwDgItUnrtqr1awEuseLgP5LX1BO5RHQI8oDsFfA+EcIkvExVh19Y2BE1wdxpCw2aSHMvkpxpTq7VoOlIydLNgPfLegaySfxTm0L8OEAXkLDYH3f8b1+UjGLs0qgt4pwxEYF+mSIAHqPNJ/ynWoMswryA+oCuuqB8723wmGlQhmjeQttYjiqdDda6Z9b9Vsuvhl9rskyLjwwUk0A5XosMdkZwaYNTrQiZ5bl/59Z2/dFRCOSrERPKdaC+hlaLBdoCTE6ASSn6TQQ==
    pypi-packagedocs:
      directory: /backup/pypi/packagedocs
      user: pypi
      increment_retention: 7D
      authorized_key: ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAzAygdki5c3mszRXLv5fZmAkcDg6sFOjKt2TROCqC6KjAR0kX/lASYfj47yavmC5AZM+AM10T7LuwDgItUnrtqr1awEuseLgP5LX1BO5RHQI8oDsFfA+EcIkvExVh19Y2BE1wdxpCw2aSHMvkpxpTq7VoOlIydLNgPfLegaySfxTm0L8OEAXkLDYH3f8b1+UjGLs0qgt4pwxEYF+mSIAHqPNJ/ynWoMswryA+oCuuqB8723wmGlQhmjeQttYjiqdDda6Z9b9Vsuvhl9rskyLjwwUk0A5XosMdkZwaYNTrQiZ5bl/59Z2/dFRCOSrERPKdaC+hlaLBdoCTE6ASSn6TQQ==
    counter-redis:
      directory: /backup/counter/redis
      user: redis
      increment_retention: 7D
      authorized_key: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDxTag+DnPlV+9FEOuN0CtPhT8Al2yGKrbepmwWQRkYdcFEr6ZUUvhsaiDLQlQDaTxCtlbZnahyMR7Xo5SwnZLk4vbimIIAciqKdoFyBc1qbltxoj9cZwadKmMj2wCp4krOnzpR3arysBaEQ//gP2iRlZGAwJzI00L66IZURgYyoUVXYoa9rEEtaLfy/yVTA1TFbQPzBsPdptOlkPE8o7LkbniOlGER5sqrjCaXi1mrkcMUuIuxD0B6CSFIXS61Nu1VIVa9j60FIcfgWT+kMIOb/MqbHWcaVOfKSPcLClltQ1an2wpp3vpIj0L51rBRpGDsYU3oUIgrSQuCMv4/ljix
