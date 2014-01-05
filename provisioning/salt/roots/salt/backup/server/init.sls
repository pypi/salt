
include:
  - backup.base

{% for volume, mount in salt['pillar.get']('backup-server:volumes').iteritems() %}
{{ volume }}-mkfs:
  cmd.run:
    - name: 'yes y | mkfs.ext4 {{ volume }}'
    - unless: 'file -s {{ volume }} | grep ext4'

{{ mount }}:
  mount.mounted:
    - device: {{ volume }}
    - fstype: ext4
    - mkmnt: True
    - opts:
      - defaults
{% endfor %}


