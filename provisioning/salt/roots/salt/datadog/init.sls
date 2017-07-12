
/etc/pki/rpm-gpg/RPM-GPG-KEY-DATADOG:
  file.managed:
    - source: salt://datadog/config/RPM-GPG-KEY-DATADOG
    - user: root
    - group: root
    - mode: 444

datadog_repo:
  pkgrepo.managed:
    - humanname: Datadog, Inc.
    - baseurl: https://yum.datadoghq.com/rpm/$basearch/
    - gpgcheck: 1
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-DATADOG
    - require:
      - file: /etc/pki/rpm-gpg/RPM-GPG-KEY-DATADOG


{% if 'datadog_api_key' in pillar %}
datadog-agent:
  pkg:
    - installed
    - require:
      - pkgrepo: datadog_repo
  service:
    - running
    - enable: True
    - require:
      - ini: /etc/dd-agent/datadog.conf
      - pkg: datadog-agent
    - watch:
      - ini: /etc/dd-agent/datadog.conf

/etc/dd-agent/datadog.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 0644
    - replace: False
  ini.options_present:
    - sections:
        Main:
            dd_url: https://app.datadoghq.com
            api_key: {{ pillar.get('datadog_api_key') }}
    - require:
      - file: /etc/dd-agent/datadog.conf

{% endif %}
