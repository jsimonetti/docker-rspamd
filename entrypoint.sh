#!/bin/sh
set -e

RSPAMD_CONTROLLER_PASSWORD="${RSPAMD_CONTROLLER_PASSWORD:-q1}"
DNSSERVER="${DNSSERVER:-dnsserver:53:1}"

if [ "$1" = 'rspamd' ]; then
    echo 'password = "'$RSPAMD_CONTROLLER_PASSWORD'";' > /etc/rspamd/local.d/worker-controller.inc
    echo 'enable_password = "'$RSPAMD_CONTROLLER_PASSWORD'";' >> /etc/rspamd/local.d/worker-controller.inc
    echo -e 'dns {\n nameserver = ["'$DNSSERVER'"];\n}' >> /etc/rspamd/override.d/options.inc
    exec "$@"
fi

exec "$@"

