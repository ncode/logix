# Logix - Transports your local syslog to Graylog2 via AMQP
* http://graylog2.org/about

## Why should I use it?

When you are sending lots of udp log events over the network packet loss can happen, or even
using a tcp log sender you can get a slow response on your server depending on how much logs
your remote log server is receiving simultaneously.

So... what can you do to avoid it?

logix can help you using its daemon receiving your log events
and queueing you messages on AMQP. You can easily get rid of log event
losses caused by udp and any performance issue that could be caused by
concurrency using tcp remote syslog.

logix queues your log events on any AMQP Server and you can easy setup
your <a href="https://github.com/Graylog2/graylog2-server">greylog2-server</a> to consume this queue and index your logs on demand.

## Usage:
### Setup your AMQP and Graylog2
* http://www.rabbitmq.com/getstarted.html
* https://github.com/Graylog2/graylog2-server/wiki/AMQP

### on MacOS X:

    $ vim /etc/syslog.conf
    *.notice;authpriv,remoteauth,ftp,install,internal.none  @127.0.0.1:8000
    $ launchctl unload /System/Library/LaunchDaemons/com.apple.syslogd.plist
    $ launchctl load /System/Library/LaunchDaemons/com.apple.syslogd.plist

### on Linux:

    $ vim /etc/rsyslog.d/logix.conf
    *.*  @127.0.0.1:8000
    $ /etc/init.d/rsyslog restart

### Running:
    $ LOGIX_CONF=src/etc/logix.conf src/bin/logix -u $USER &
    $ logger test

## Depends:
* python-kombu (>= 1.4.3)
* python-gevent (>= 0.13.6)
* python-supay
* syslog or rsyslog :D

## Todo
* would benefit of an internal backlog queue
