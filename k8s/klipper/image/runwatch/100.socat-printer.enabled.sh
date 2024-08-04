#!/usr/bin/env bash

if [[ -z "${SOCAT_PRINTER_TYPE}" ]]; then
  SOCAT_PRINTER_TYPE="tcp"
fi
if [[ -z "${SOCAT_PRINTER_LOG}" ]]; then
  SOCAT_PRINTER_LOG="-lf \"$SOCAT_PRINTER_LOG\""
fi
if [[ -z "${SOCAT_PRINTER_LINK}" ]]; then
  SOCAT_PRINTER_LINK="/dev/printer"
fi

BINARY="sudo"
PARAMS="socat $INT_SOCAT_LOG-d -d -d pty,link=$SOCAT_PRINTER_LINK,raw,user=root,mode=777,ignoreeof,echo=0 $SOCAT_PRINTER_TYPE:$SOCAT_PRINTER_HOST:$SOCAT_PRINTER_PORT"

######################################################

CMD=$1

if [[ -z "${CONFIG_LOG_TARGET}" ]]; then
  LOG_FILE="/dev/null"
else
  LOG_FILE="${CONFIG_LOG_TARGET}"
fi

case $CMD in

describe)
    echo "Sleep $PARAMS"
    ;;

## exit 0 = is not running
## exit 1 = is running
is-running)
    if pgrep -f "$BINARY $PARAMS" >/dev/null 2>&1 ; then
        exit 1
    fi
    # stop octoprint if socat is not running 
    if pgrep -f "python -m octoprint" >/dev/null 2>&1 ; then
        echo "stopping klipper & moonraker since socat is not running"
        kill -9 $(pgrep -f "/opt/venv-klipper/bin/python")
        kill -9 $(pgrep -f "/opt/venv-moonraker/bin/python")
    fi
    exit 0
    ;;

start)
    echo "Starting... $BINARY $PARAMS" >> "$LOG_FILE"
    sudo mkdir -p /dev/serial/by-id
    $BINARY $PARAMS 2>$LOG_FILE >$LOG_FILE &
    # delay other checks for 5 seconds
    sleep 5
    ;;

start-fail)
    echo "Start failed! $BINARY $PARAMS"
    ;;

stop)
    echo "Stopping... $BINARY $PARAMS"
    kill -9 $(pgrep -f "$BINARY $PARAMS")
    ;;

esac