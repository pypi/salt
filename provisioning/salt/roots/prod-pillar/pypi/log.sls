
firewall:
  syslog_tcp_72:
    source: 199.27.72.0/24
    port: 514
  syslog_tcp_77:
    source: 199.27.77.0/24
    port: 514
  syslog_udp_72:
    source: 199.27.72.0/24
    port: 514
    protocol: udp
  syslog_udp_77:
    source: 199.27.77.0/24
    port: 514
    protocol: udp
  redis:
    source: 172.16.57.0/24
    port: 6379
  elasticsearch:
    source: 172.16.57.0/24
    port: 9200
