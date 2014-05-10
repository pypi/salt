
security_yum_extensions:
  pkg.installed:
    - pkgs:
      - yum-plugin-security
      - yum-cron

yum_cron_security_only:
  file.replace:
    - name: /etc/sysconfig/yum-cron
    - path: /etc/sysconfig/yum-cron
    - pattern: '^YUM_PARAMETER=$'
    - repl: 'YUM_PARAMETER="--security"'
    - require:
      - pkg: security_yum_extensions
