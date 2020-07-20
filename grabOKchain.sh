#!/bin/bash

# Adjust as needed.
TEXTFILE_COLLECTOR_DIR=/var/spool/okchain
#TEXTFILE_COLLECTOR_DIR=/tmp

# Note the start time of the script.
START="$(date +%s)"

OKCHAINVERSION=`okchaincli status | jq '.node_info.version'| tr -d '"'`
OKCHAIN_LASTBLK=`okchaincli status | jq '.sync_info.latest_block_height' | tr -d '"'`
OKCHAIN_MONIKER=`okchaincli status | jq '.node_info.moniker'| tr -d '"'`

echo "$OKCHAIN_MONIKER v$OKCHAINVERSION $OKCHAIN_LASTBLK"

# Write out metrics to a temporary file.
END="$(date +%s)"
cat << EOF > "$TEXTFILE_COLLECTOR_DIR/okchain.prom.$$"
okchain_duration_seconds $(($END - $START))
okchain_last_run_seconds $END
okchain_last_block{name="$OKCHAIN_MONIKER"} $OKCHAIN_LASTBLK
okchain_version{version="$OKCHAINVERSION"} 1
EOF

# Rename the temporary file atomically.
# This avoids the node exporter seeing half a file.
mv "$TEXTFILE_COLLECTOR_DIR/okchain.prom.$$" "$TEXTFILE_COLLECTOR_DIR/okchain.prom"


