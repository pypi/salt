
include:
  - firewall

niceities:
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
