include:
  - secrets.monitoring:
      defaults:
        server_names:
          - '_'
        secret_key: deadbeef
      key: monitoring_secrets

firewall:
  riemann_ports:
    port: 5555:5556
    source: 172.16.57.0/24
  riemann_udp_ports:
    port: 5556
    source: 172.16.57.0/24
  riemann_graphite:
    port: 2002
    source: 172.16.57.0/24
  graphite_ports:
    port: 2003:2004
    source: 172.16.57.0/24
  graphite_query_port:
    port: 7002
    source: 172.16.57.0/24
  http:
    port: 80
  https:
    port: 443

riemann:
  host: 0.0.0.0
  graphite_host: 0.0.0.0
  graphite_port: 2002
  graphite_downstream_host: 127.0.0.1
  graphite_downstream_port: 2003

graphite:
  allowed_hosts: '*'
  sqlite3_path: /var/lib/graphite-web/graphite.db
  https_only: true

carbon:
  line_receiver_interface: 0.0.0.0
  line_reciver_port: 2003
  pickle_receiver_interface: 0.0.0.0
  pickle_receiver_port: 2004
  cache_query_interface: 0.0.0.0
  cache_query_port: 7002
