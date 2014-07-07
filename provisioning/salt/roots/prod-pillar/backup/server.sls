
backup-server:
  volumes:
    /dev/xvdb: /backup
  backups:
    postgres-archives:
      directory: /backup/postgres/archives
      user: postgres
      increment_retention: 7D
      authorized_key: ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA2dx+0KOJL2xDThEIMWzrxyOZnN7ogA1ytDAB95xZdClRO4Jw6Mvht/PdLhhYQm9iKNe2XRcVOYOJ6hvLqKSGbjn95MWoLa/E5+WUYfIWJdrMCr6GhnoVeNFLu6M64mCkSZdadPuRkAA2W6+No4aEKLooGtzAnkJvlbm5M6h+5/JD2TpTOfI1DgozlqB08FtCeMQZtS8X0LWfhCekQDCVmAMeFee10D7HQj9xEP90eKVBnDSJ9ZC/WhBnTR1an7pCbOdlA8qzZ1SiBTadju+A5MevtzM4QN0EqRXuE69C8k/FA0p72LP6kAPlYk0O/eqt/n/w+RR6dF/MEG/6mL7WUw==
    postgres-base:
      directory: /backup/postgres/base
      user: postgres
      increment_retention: 7D
      authorized_key: ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA2dx+0KOJL2xDThEIMWzrxyOZnN7ogA1ytDAB95xZdClRO4Jw6Mvht/PdLhhYQm9iKNe2XRcVOYOJ6hvLqKSGbjn95MWoLa/E5+WUYfIWJdrMCr6GhnoVeNFLu6M64mCkSZdadPuRkAA2W6+No4aEKLooGtzAnkJvlbm5M6h+5/JD2TpTOfI1DgozlqB08FtCeMQZtS8X0LWfhCekQDCVmAMeFee10D7HQj9xEP90eKVBnDSJ9ZC/WhBnTR1an7pCbOdlA8qzZ1SiBTadju+A5MevtzM4QN0EqRXuE69C8k/FA0p72LP6kAPlYk0O/eqt/n/w+RR6dF/MEG/6mL7WUw==
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
    jython-site:
      directory: /backup/jython-site
      user: jython
      increment_retention: 7D
      authorized_key: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDsmiVmvnhwQsvRCjyvnGMdkidVwD9j8FdbI8rhD2dfsYHC4URKTOhkDAHBlIN3DrFBcR++UKyyJkoxaoJGNt+3xKuRVO6lUEl6e9iuIQ0baI5Ds55uCpaeBNhRM2Oib83O8tu82gQLKHtZLh755O3fnilOPvGrwOUss2s9N9Z/AvqIn61/zbEIzTNtrw0EqtJR//5YVotHBf8OMC49Qgvcu1f+/d/MEm9WoyUTzSmgL/8M7urgpuxP+fANXOTVMteGOjKojf9UCXy5EY3pKL4ckJYs85+0xKytlxbNobkV9kydiFFlnuThyCDQ1RBwkYYeDVJFBuQWKAMLYA6RZXBD
