
import json
import socket

import collectd

# uWSGI stat sock to read. Override in config by specifying 'SocketPath'.
SOCK = '/var/run/pypi/pypi-stats.sock'

def configure_callback(conf):
    global SOCK
    for node in conf.children:
        if node.key == 'SocketPath':
            SOCK = node.values[0]
        else:
            collectd.warning('uwsgi_stats plugin: Unknown config key: %s.'
                             % node.key)

def read_callback():
    s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    s.connect(SOCK)

    js = ''
    while True:
        data = s.recv(4096)
        if len(data) < 1:
            break
        js += data.decode('utf8')

    s.close()

    dd = json.loads(js)

    worker_statuses = [w['status'] for w in dd['workers']]
    counter = {'total': len(worker_statuses), 'idle': 0, 'busy': 0}
    for status in worker_statuses:
        counter[status] += 1

    idle = collectd.Values(type='gauge')
    idle.plugin='pypi_backend.uwsgi.idle'
    idle.dispatch(values=[int(counter['idle'])])

    busy = collectd.Values(type='gauge')
    busy.plugin='pypi_backend.uwsgi.busy'
    busy.dispatch(values=[int(counter['busy'])])

    total = collectd.Values(type='gauge')
    total.plugin='pypi_backend.uwsgi.total'
    total.dispatch(values=[int(counter['total'])])

# register callbacks
collectd.register_config(configure_callback)
collectd.register_read(read_callback)

