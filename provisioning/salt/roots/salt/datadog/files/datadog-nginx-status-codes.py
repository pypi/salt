"""
Lifted from https://gist.github.com/technovangelist/6090e4a66bc60b99c566
"""

from datetime import datetime
import time
import re

METRIC_TYPES = {
    '5': 'nginx.net.5xx_status',
    '4': 'nginx.net.4xx_status',
    '3': 'nginx.net.3xx_status',
    '2': 'nginx.net.2xx_status',
    '1': 'nginx.net.1xx_status'
}

def parse(log, line):
    if len(line) == 0:
        log.info("Skipping empty line")
        return None
    timestamp = getTimestamp(line)
    status = line.split()[8]
    objToReturn = []
    try:
        objToReturn.append((METRIC_TYPES[status[0]], timestamp, 1, {'metric_type': 'counter'}))
    except KeyError:
        pass
    return objToReturn

def getTimestamp(line):
    line_parts = line.split()
    dt = line_parts[3]
    date = datetime.strptime(dt, "[%d/%b/%Y:%H:%M:%S")
    date = time.mktime(date.timetuple())
    return date

if __name__ == "__main__":
    import sys
    import pprint
    import logging
    logging.basicConfig()
    log = logging.getLogger()
    lines = open(sys.argv[1]).readlines()
    pprint.pprint([parse(log, line) for line in lines])
