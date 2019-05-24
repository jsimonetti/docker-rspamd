#!/bin/sh
set -e

RSPAMD_CONTROLLER_PASSWORD="${RSPAMD_CONTROLLER_PASSWORD:-q1}"

if [ "$1" = 'rspamd' ]; then
    echo 'password = "'$RSPAMD_CONTROLLER_PASSWORD'";' > /etc/rspamd/local.d/worker-controller.inc
    echo 'enable_password = "'$RSPAMD_CONTROLLER_PASSWORD'";' >> /etc/rspamd/local.d/worker-controller.inc
    exec "$@"
fi

exec "$@"

