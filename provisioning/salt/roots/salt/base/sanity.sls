
niceties:
  pkg.installed:
    - pkgs:
      - htop
      - tmux
      - tree
      - bash-completion
      {% if grains['os'] == 'CentOS' %}
      - vim-enhanced
      {% endif %}

time-sync:
  pkg.installed:
    - pkgs:
      - ntp
      - ntpdate

{% if grains['os'] == 'CentOS' %}
ntpd:
{% else %}
ntp:
{% endif %}
  service:
    - running
    - enable: True 
