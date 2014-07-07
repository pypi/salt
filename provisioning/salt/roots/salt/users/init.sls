
{% set users = [] %}
{% for k,v in pillar.items() %}
  {% if k.startswith('users-') %}
    {% for user, config in v.items() %}
      # XXX We should check every role for a particular machine.
      {% if k == 'users-admin' or grains['roles'][0] in config['roles'] %}
        {% do config.update({'user_tree': k}) %}
        {% do users.append((user, config)) %}
      {% endif %}
    {% endfor %}
  {% endif %}
{% endfor %}

/home/psf-users:
  file.directory:
    - mode: 755

{% for user in users %}
{% set (user_name, user_config) = user %}

{{ user_name }}-user:
  user.present:
    - name: {{ user_name }}
    - home: /home/psf-users/{{ user_name }}
    - createhome: True
    - groups:
      {% for group in user_config.get('add_group', []) %}
      - {{group}}
      {% endfor %}
      # Some roles imply every (human) user gets a particular group.
      {% if 'jython_web' in grains['roles'] %}
      - jython
      {% endif %}
    - require:
      - file: /home/psf-users
    {% if 'add_group' in user_config %}
      {% for group in user_config['add_group'] %}
      - group: {{group}}
      {% endfor %}
    {% endif %}
    {% if 'jython_web' in grains['roles'] %}
      - group: jython
    {% endif %}

{{ user_name }}-ssh_dir:
  file.directory:
    - name: /home/psf-users/{{ user_name }}/.ssh
    - user: {{ user_name }}
    - mode: 700
    - require:
      - user: {{ user_name }}

{{ user_name }}-ssh_key:
  file.managed:
    - name: /home/psf-users/{{ user_name }}/.ssh/authorized_keys
    - user: {{ user_name }}
    - mode: 600
    - source: salt://users/config/authorized_keys.jinja
    - template: jinja
    - context:
      user: {{ user_name }}
      user_tree: {{ user_config['user_tree'] }}
    - require:
      - user: {{ user_name }}

{% endfor %}
