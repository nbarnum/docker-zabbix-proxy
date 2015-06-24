#!/bin/bash

usage () {
    echo "usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  REQUIRED:"
    echo "    -s, --host           Zabbix hostname to use for Zabbix proxy (Hostname= in conf)."
    echo "    -z, --zabbix-server  Zabbix server IP or DNS name (Server= in zabbix_proxy.conf)."
    echo "  OPTIONAL:"
    echo "    -m, --monit          Command to pass to Monit {start|stop|restart|shell|status|summary}. Default: run"
    echo "    -p, --port           Zabbix server port to send to (ServerPort= in zabbix_proxy.conf). Defaults to 10051."
}

if [ "$#" -lt 4 ]; then
    echo "ERROR: too few options"
    usage
    exit 1
fi

ZABBIX_PORT="10051"

# http://stackoverflow.com/a/14203146/3236644
while [[ $# > 0 ]]
do
  key="$1"

  case $key in
      -m|--monit)
          MONIT_CMD="$2"
          shift #past argument
      ;;
      -p|--port)
          ZABBIX_PORT="$2"
          shift # past argument
      ;;

      -s|--host)
          ZABBIX_HOSTNAME="$2"
          shift # past argument
      ;;
      -z|--zabbix-server)
          ZABBIX_SERVER="$2"
          shift # past argument
      ;;
      *)
          echo "ERROR: unrecognized option(s)"
          usage
          exit 1
      ;;
  esac
  shift # past argument or value
done

# Default to "run" if none was provided
if [ -z "$MONIT_CMD" ]; then
    MONIT_CMD="run"
fi

if [ -z "$ZABBIX_SERVER" ]; then
    echo "ERROR: missing -z or --zabbix-server option"
    usage
    exit 1
else
    sed -i "s/ZABBIX_SERVER/$ZABBIX_SERVER/g" /etc/zabbix/zabbix_proxy.conf
fi

if [ -z "$ZABBIX_HOSTNAME" ]; then
    echo "ERROR: missing -s or --host option"
    usage
    exit 1
else
    sed -i "s/ZABBIX_HOSTNAME/$ZABBIX_HOSTNAME/g" /etc/zabbix/zabbix_proxy.conf
fi

# We either use the default or what was passed in
sed -i "s/ZABBIX_PORT/$ZABBIX_PORT/g" /etc/zabbix/zabbix_proxy.conf

# Start Zabbix proxy with monit
# https://github.com/berngp/docker-zabbix/blob/master/scripts/entrypoint.sh
_cmd="/usr/bin/monit -d 10 -Ic /etc/monit/monitrc"
_shell="/bin/bash"

case "$MONIT_CMD" in
  run)
    echo "Running Monit... "
    exec /usr/bin/monit -d 10 -Ic /etc/monit/monitrc
    ;;
  stop)
    $_cmd stop all
    RETVAL=$?
    ;;
  restart)
    $_cmd restart all
    RETVAL=$?
    ;;
  shell)
    $_shell
    RETVAL=$?
    ;;
  status)
    $_cmd status all
    RETVAL=$?
    ;;
  summary)
    $_cmd summary
    RETVAL=$?
    ;;
  *)
    echo $"Usage: $0 {start|stop|restart|shell|status|summary}"
    RETVAL=1
esac
