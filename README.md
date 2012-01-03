# Graylog Extended Log Format enqueuer through kombu for Graylog2
* http://graylog2.org/about

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
    $ LOGIX_CONF=src/etc/logix.conf src/bin/logix &
    $ logger test

## Todo
* needs tweak on amqp pool
* would benefit of an internal backlog queue
