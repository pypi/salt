
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
  file.absent
