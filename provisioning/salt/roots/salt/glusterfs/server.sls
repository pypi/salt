
include:
  - firewall
  - glusterfs.base

glusterfs-server:
  pkg:
    - installed
    - require:
      - pkgrepo: gluster-el6

glusterd:
  service:
    - running
    - enable: True
    - require:
      - pkg: glusterfs-server

{% for brick, mount in salt['pillar.get']('gluster_cluster:bricks').iteritems() %}
mk-brkfs:
  cmd.run:
    - name: 'yes y | mkfs.ext4 {{ brick }}'
    - unless: 'file -s {{ brick }} | grep ext4'

{{ mount }}:
  mount.mounted:
    - device: /dev/sdb
    - fstype: ext4
    - mkmnt: True
    - opts:
      - defaults
{% endfor %}

{% for peer in salt['pillar.get']('gluster_cluster:peers') %}
probe-peer-{{ peer }}:
  cmd.run:
    - name: 'ping -t1 -c1 {{ peer }} && gluster peer probe {{ peer }}'
    - unless: 'ping -t1 -c1 {{ peer }} && gluster peer probe {{ peer }}'
    - require:
      - service: glusterd
{% endfor %}

{% for volume, config in salt['pillar.get']('gluster_cluster:volumes').iteritems() %}
create-volume-{{ volume }}:
  cmd.run:
    - name: 'gluster volume create {{ volume }} replica {{ config['replication'] }} {{ " ".join(config['nodes']) }}'
    - unless: 'gluster volume info {{ volume }}'
    - require:
      {% for peer in salt['pillar.get']('gluster_cluster:peers') %}
      - cmd: probe-peer-{{ peer }}
      {% endfor %}

{% if config.get('auth_allow', False) %}
set-auth_allow-{{ volume }}:
  cmd.run:
    - name: 'gluster volume set {{ volume }} auth.allow {{ config.get('auth_allow') }}'
    - unless: 'gluster volume info {{ volume }} | grep "auth.allow: {{ config.get('auth_allow') }}"'
    - require:
      - cmd: create-volume-{{ volume }}
{% endif %}

{% if config.get('network_ping-timeout', False) %}
set-network_ping-timeout-{{ volume }}:
  cmd.run:
    - name: 'gluster volume set {{ volume }} network.ping-timeout {{ config.get('network_ping-timeout') }}'
    - unless: 'gluster volume info {{ volume }} | grep "network.ping-timeout: {{ config.get('network_ping-timeout') }}"'
    - require:
      - cmd: create-volume-{{ volume }}
{% endif %}

start-volume-{{ volume }}:
  cmd.run:
    - name: 'gluster volume start {{ volume }}'
    - unless: 'gluster volume info {{ volume }} | grep "^Status: Started$"'
    - require:
      - cmd: create-volume-{{ volume }}
{% endfor %}
