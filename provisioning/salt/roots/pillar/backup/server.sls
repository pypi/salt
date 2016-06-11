
backup-server:
  volumes:
    /dev/sdb: /backup
  backups:
    devpypi-files:
      directory: /backup/devpypi/files
      user: devpypi
      increment_retention: 10m
      authorized_key: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCxqABhu46JE5zT68uNwpBdmqI/eYfepfA9PU8AxbGR96u5rPd8xyKJ2ZzTUgjrCKWLim4jutFgAtfCwkfjm/FrHQWNJZhZtQ1gT8a/bpIjHddjOFlELja1vFKkQsU6dsmYGTZxwByeMQl1+TWE5xmGrmqsgNnK+Twi01TCUmYs36M8OQGXle664XAapfc+4cAU4Clf3mH7xFIBJnCS12v5ES1J4pmnfBVMT85lGJMDW/vDI5Yx2A85bKOCwle1XpGsxLLfvvg7faNiCBjpj//pSEAI52tSq0hLtYSS5WJBz1tfJQPECCXVxa6LHKJB6RDT3eYyMQSugFSCrHxQ8j/F
