import os
import calendar
from datetime import datetime

import collectd

# Mirror Directory to read. Override in config by specifying 'MirrorDir'.
MIRROR_DIR = '/data/pypi-mirror'

def configure_callback(conf):
    global MIRROR_DIR
    for node in conf.children:
        if node.key == 'MirrorDir':
            MIRROR_DIR = node.values[0]
        else:
            collectd.warning('pypi_mirror plugin: Unknown config key: %s.'
                             % node.key)

def read_callback():
    with open(os.path.join(MIRROR_DIR, 'status'), 'r') as f:
        current_serial = f.read()

    with open(os.path.join(MIRROR_DIR, 'web', 'last-modified'), 'r') as f:
        last_modified_timestamp = f.read().rstrip('\n')

    cur_serial = collectd.Values(type='gauge')
    cur_serial.plugin='pypi_mirror.current_serial'
    cur_serial.dispatch(values=[int(current_serial)])

    last_modified_unix = calendar.timegm(datetime.strptime(last_modified_timestamp, "%Y%m%dT%H:%M:%S").utctimetuple())
    last_mod = collectd.Values(type='gauge')
    last_mod.plugin='pypi_mirror.last_modified'
    last_mod.dispatch(values=[int(last_modified_unix)])

# register callbacks
collectd.register_config(configure_callback)
collectd.register_read(read_callback)
