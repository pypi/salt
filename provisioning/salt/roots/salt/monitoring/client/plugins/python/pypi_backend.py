import os
import calendar
from datetime import datetime
import urllib2

import collectd

# Mirror Directory to read. Override in config by specifying 'MirrorDir'.
HOST = 'localhost'
PORT = 9000

def configure_callback(conf):
    global HOST, PORT
    for node in conf.children:
        if node.key == 'Host':
            HOST = node.values[0]
        if node.key == 'Port':
            PORT = int(node.values[0])
        else:
            collectd.warning('pypi_backend plugin: Unknown config key: %s.'
                             % node.key)

def read_callback():
    SERIAL_URL = "https://%s:%s/serial" % (HOST, PORT)
    TIME_URL = "https://%s:%s/daytime" % (HOST, PORT)

    handler = urllib2.urlopen(SERIAL_URL)
    current_serial = handler.read().rstrip('\n')

    handler = urllib2.urlopen(TIME_URL)
    last_modified_timestamp = handler.read().rstrip('\n')

    cur_serial = collectd.Values(type='gauge')
    cur_serial.plugin='pypi_backend.current_serial'
    cur_serial.dispatch(values=[int(current_serial)])

    last_modified_unix = calendar.timegm(datetime.strptime(last_modified_timestamp, "%Y%m%dT%H:%M:%S").utctimetuple())
    last_mod = collectd.Values(type='gauge')
    last_mod.plugin='pypi_backend.last_modified'
    last_mod.dispatch(values=[int(last_modified_unix)])

# register callbacks
collectd.register_config(configure_callback)
collectd.register_read(read_callback)
