
niceties:
  pkg.installed:
    - pkgs:
      - htop
      - tmux
      - tree
      - bash-completion
      - vim-enhanced

time-sync:
  pkg.installed:
    - pkgs:
      - ntp
      - ntpdate

ntpd:
  service:
    - running
    - enable: True 

/etc/profile.d/yum.sh:
  file.managed:
    - user: root
    - group: root
    - mode: 755
    - contents: |
        export NSS_DISABLE_HW_GCM=1
        export NSS_DISABLE_HW_AES=1
