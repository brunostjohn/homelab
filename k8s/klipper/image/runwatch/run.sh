#!/usr/bin/env bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
B=$(which bash)

if [[ -z "${DEBUG_VERBOSE}" ]]; then
  CONFIG_DEBUG_VERBOSE=0
else
  CONFIG_DEBUG_VERBOSE="${DEBUG_VERBOSE}"
fi

if [[ -z "${PAUSE_BETWEEN_CHECKS}" ]]; then
  CONFIG_PAUSE_BETWEEN_CHECKS=2
else
  CONFIG_PAUSE_BETWEEN_CHECKS="${PAUSE_BETWEEN_CHECKS}"
fi

if [[ -z "${LOG_TARGET}" ]]; then
  CONFIG_LOG_TARGET="/dev/stdout"
else
  CONFIG_LOG_TARGET="${LOG_TARGET}"
fi

echo "---- Config:"
echo "DEBUG_VERBOSE        $CONFIG_DEBUG_VERBOSE"
echo "PAUSE_BETWEEN_CHECKS $CONFIG_PAUSE_BETWEEN_CHECKS"
echo "LOG_TARGET           $CONFIG_LOG_TARGET"
echo "---- Files:"
cd "$DIR"
for FILE in `ls *.enabled.sh | sort`; do
  echo "> $FILE"
done
echo "===="
echo ""

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
    echo "---- STOPPING PROCESSES IN REVERSE ORDER"
    cd "$DIR"
    for FILE in `ls *.enabled.sh | sort -r`; do
        echo "==== $FILE"
        $B "$FILE" stop
        echo -e '\b\b\b\b OK'
    done
    exit 0
}

export CONFIG_LOG_TARGET
echo "" > "$CONFIG_LOG_TARGET"
while :
do
    cd "$DIR"
    for FILE in `ls *.enabled.sh | sort`; do
        $B "$FILE" is-running
        IS_RUNNING=$?
        if [ $IS_RUNNING == 0 ]; then
            $B "$FILE" start
            $B "$FILE" is-running
            IS_RUNNING=$?
            if [ $IS_RUNNING == 0 ]; then
                $B "$FILE" start-fail
            fi
        fi
    done
    sleep $CONFIG_PAUSE_BETWEEN_CHECKS
done