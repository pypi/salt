
backup-server:
  volumes:
    /dev/xvdc: /backup
  directories:
    /backup/postgres/archives:
      user: postgres
      increment_retention: 7d
      authorized_key: ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA2dx+0KOJL2xDThEIMWzrxyOZnN7ogA1ytDAB95xZdClRO4Jw6Mvht/PdLhhYQm9iKNe2XRcVOYOJ6hvLqKSGbjn95MWoLa/E5+WUYfIWJdrMCr6GhnoVeNFLu6M64mCkSZdadPuRkAA2W6+No4aEKLooGtzAnkJvlbm5M6h+5/JD2TpTOfI1DgozlqB08FtCeMQZtS8X0LWfhCekQDCVmAMeFee10D7HQj9xEP90eKVBnDSJ9ZC/WhBnTR1an7pCbOdlA8qzZ1SiBTadju+A5MevtzM4QN0EqRXuE69C8k/FA0p72LP6kAPlYk0O/eqt/n/w+RR6dF/MEG/6mL7WUw==
    /backup/postgres/base:
      user: postgres
      increment_retention: 7d
      authorized_key: ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA2dx+0KOJL2xDThEIMWzrxyOZnN7ogA1ytDAB95xZdClRO4Jw6Mvht/PdLhhYQm9iKNe2XRcVOYOJ6hvLqKSGbjn95MWoLa/E5+WUYfIWJdrMCr6GhnoVeNFLu6M64mCkSZdadPuRkAA2W6+No4aEKLooGtzAnkJvlbm5M6h+5/JD2TpTOfI1DgozlqB08FtCeMQZtS8X0LWfhCekQDCVmAMeFee10D7HQj9xEP90eKVBnDSJ9ZC/WhBnTR1an7pCbOdlA8qzZ1SiBTadju+A5MevtzM4QN0EqRXuE69C8k/FA0p72LP6kAPlYk0O/eqt/n/w+RR6dF/MEG/6mL7WUw==
