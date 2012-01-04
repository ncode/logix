#!/bin/sh
### BEGIN INIT INFO
# Provides:          logix
# Required-Start:    $network $local_fs
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: rsyslog to Graylog2 enqueuer
# Description:       Graylog Extended Log Format enqueuer through kombu for Graylog2
### END INIT INFO

# Author: Juliano Martinez <juliano.martinez@locaweb.com.br>
PATH=/sbin:/usr/sbin:/bin:/usr/bin
DESC="rsyslog to Graylog2 enqueuer"
NAME=logix

DAEMON=logix
DAEMON_BIN=/usr/sbin/logix
DAEMON_PIDFILE=/var/run/logix.pid
SCRIPTNAME=/etc/init.d/$NAME

# Exit if the package is not installed
[ -x "$DAEMON_BIN" ] || exit 0

# Read configuration variable file if it is present
[ -r /etc/default/$NAME ] && . /etc/default/$NAME

# Define LSB log_* functions.
. /lib/lsb/init-functions

create_xconsole() {
    XCONSOLE=/dev/xconsole
    if [ "$(uname -s)" = "GNU/kFreeBSD" ]; then
        XCONSOLE=/var/run/xconsole
        ln -sf $XCONSOLE /dev/xconsole
    fi
    if [ ! -e $XCONSOLE ]; then
        mknod -m 640 $XCONSOLE p
        chown root:adm $XCONSOLE
        [ -x /sbin/restorecon ] && /sbin/restorecon $XCONSOLE
    fi
}

sendsigs_omit() {
    OMITDIR=/lib/init/rw/sendsigs.omit.d
    mkdir -p $OMITDIR
    rm -f $OMITDIR/rsyslog
    ln -s $DAEMON_PIDFILE $OMITDIR/rsyslog
}

case "$1" in
  start)
    log_daemon_msg "Starting $DESC" "$DAEMON"
    create_xconsole
    $DAEMON -a start
    case "$?" in
        0) sendsigs_omit
           log_end_msg 0 ;;
        1) log_progress_msg "already started"
           log_end_msg 0 ;;
        *) log_end_msg 1 ;;
    esac

    ;;
  stop)
    log_daemon_msg "Stopping $DESC" "$DAEMON"
    $DAEMON -a stop
    case "$?" in
        0) log_end_msg 0 ;;
        1) log_progress_msg "already stopped"
           log_end_msg 0 ;;
        *) log_end_msg 1 ;;
    esac

    ;;
  restart)
    $DAEMON -a stop
    $DAEMON -a start
    ;;
  status)
    status_of_proc -p $DAEMON_PIDFILE $DAEMON_BIN $DAEMON && exit 0 || exit $?
    ;;
  *)
    echo "Usage: $SCRIPTNAME {start|stop|restart|status}" >&2
    exit 3
    ;;
esac

:
