#!/usr/bin/python

# forked from Juliano Martinez (http://github.com/ncode/logix)
# gevent based syslog/amqp(via kombu) bridge

import os, re, sys, math, time, socket, ConfigParser
import logging
from kombu.common import maybe_declare
from kombu import BrokerConnection
from kombu.pools import producers, connections
from kombu import Exchange, Queue

import gevent
from gevent import socket, monkey, baseserver
monkey.patch_all()

severity = ['emerg', 'alert', 'crit', 'err', 'warn', 'notice', 'info', 'debug']
facility = ['kern', 'user', 'mail', 'daemon', 'auth', 'syslog', 'lpr', 'news', 'uucp', 
            'cron', 'authpriv', 'ftp', 'ntp', 'audit', 'alert', 'at', 'local0', 'local1', 
            'local2', 'local3', 'local4', 'local5', 'local6', 'local7']

fs_match = re.compile("<(.+)>(.*)", re.I)

def parse_and_queue_datagram(line, host, queue, connection):
    parsed = {}
    parsed['line'] = line.strip()
    (fac, sev) = _calc_lvl(parsed['line'])
    parsed['host'] = host
    parsed['timestamp'] = time.time()
    parsed['facility'] = fac
    parsed['severity'] = sev
    parsed['version'] = '1.0'
    parsed['short_message'] = "<%s> %s %s" % (sev, os.uname()[1], parsed['line'])

    with connections[connection].acquire(block=True) as conn:
        with conn.SimpleQueue(queue) as queue:
            queue.put(parsed, serializer="json", compression="zlib")

def _calc_lvl(line):
    lvl = fs_match.split(line)
    if lvl and len(lvl) > 1:
        i = int(lvl[1])
        fac = int(math.floor(i / 8))
        sev = i - (fac * 8)
        return (facility[fac], severity[sev])
    return (None, None)

if __name__ == '__main__':
    logging.info("Starting Logix")

    config_file = '../etc/logix.conf'
    if not os.path.isfile(config_file):
        logging.error("Config file %s not found" % config_file)
        sys.exit(1)

    config = ConfigParser.RawConfigParser()
    config.read(config_file)

    # config.getint('transport', 'connection_pool_size')
    connection = BrokerConnection(config.get('transport','url')) 

    s = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM, proto=socket.IPPROTO_UDP)
    s.bind(('',config.getint('server', 'port')))

    while True:
        data, peer = s.recvfrom(config.getint('server', 'max_syslog_line_size'))
        logging.debug("New data: %s" % data)
        gevent.spawn(parse_and_queue_datagram, data, peer, config.get('transport',
            'queue'), connection)

