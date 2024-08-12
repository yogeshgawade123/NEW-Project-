#!/bin/bash
#set -x
LOG_FILE="/var/log/secure"
LAST_CHECK_FILE="/tmp/last_check_timestamp"
TEMP_FILE="/tmp/falled"
CURRENT_TIMESTAMP=$( date +%Y.%m.%d.%H:%M:%S)

if [ ! -f "$LAST_CHECK_FILE" ]; then
     date +"%Y.%m.%d %H:%M:%S" > "$LAST_CHECK_FILE"
fi

LAST_CHECK_TIMESTAMP=$(cat "$LAST_CHECK_FILE")

grep "Failed password" "$LOG_FILE" | while read -r line; do
    LOG_TIME=$(echo "$line" | awk '{print $1, $2, $3}') 

    LOG_TIMESTAMP=$(date -d "$LOG_TIME" +"%Y.%m.%d.%H:%M:%S")

    if [[ "$LOG_TIMESTAMP" > "$LAST_CHECK_TIMESTAMP" ]]; then
        echo "$line" >> "$TEMP_FILE"
    fi
done

echo "$CURRENT_TIMESTAMP" > "$LAST_CHECK_FILE"

if [ -s "$TEMP_FILE" ]; then
    echo "Unauthorized login attempts detected:"
    cat "$TEMP_FILE"
else
    echo "No unauthorized login attempts since the last check."
fi

if [ -s "$TEMP_FILE" ]; then
    echo "Unauthorized login attempts detected:"
    cat "$TEMP_FILE"
else
    echo "No unauthorized login attempts since the last check."
fi

rm "$TEMP_FILE"
