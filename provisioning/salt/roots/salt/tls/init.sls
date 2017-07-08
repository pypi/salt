crypto_packages:
  pkg.installed:
    - pkgs:
      - openssl

generate_dhparams:
  cmd.run:
    - name: openssl dhparam -out /etc/pki/tls/private/dhparams.pem 4096
    - creates: /etc/pki/tls/private/dhparams.pem
    - require:
      - pkg: crypto_packages

lego_extract:
  archive.extracted:
    - name: /usr/local/bin/
    - if_missing: /usr/local/bin/lego
    - source: https://github.com/xenolf/lego/releases/download/v0.3.1/lego_linux_amd64.tar.xz
    - source_hash: sha256=cee9511099e9864968ac9c68f2f8d77fd927cda17957546d99faaf93f310538a
    - archive_format: tar
    - tar_options: -J --strip-components=1 lego/lego

/etc/lego:
  file.directory:
    - user: root
    - group: root
    - mode: 0755

/etc/lego/.well-known/acme-challenge:
  file.directory:
    - user: nginx
    - group: root
    - mode: 0750
    - makedirs: True
    - require:
      - file: /etc/lego

lego_bootstrap:
  cmd.run:
    - name: /usr/local/bin/lego -a --email="infrastructure-staff@python.org" --domains="{{ grains['fqdn'] }}" --webroot /etc/lego --path /etc/lego --key-type ec256 run
    - creates: /etc/lego/certificates/{{ grains['fqdn'] }}.json
    - require:
      - file: /etc/lego/.well-known/acme-challenge
      - archive: lego_extract

lego_renew:
  cron.present:
    - name: /usr/local/bin/lego -a --email="infrastructure-staff@python.org" --domains="{{ grains['fqdn'] }}" --webroot /etc/lego --path /etc/lego --key-type ec256  renew --days 30 && /sbin/service nginx reload
    - hour: 0
    - minute: random
