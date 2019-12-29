FROM alpine:latest

RUN	apk add --no-cache tini rspamd rspamd-controller rspamd-proxy rspamd-fuzzy

RUN	echo 'type = "console";' > /etc/rspamd/override.d/logging.inc \
	&& echo 'bind_socket = "*:11334";' > /etc/rspamd/override.d/worker-controller.inc \
	&& echo 'pidfile = false;' > /etc/rspamd/override.d/options.inc \
	&& echo 'servers = "redis:6379";' > /etc/rspamd/local.d/greylist.conf \
	&& echo 'bind_socket = "localhost:11335";' > /etc/rspamd/local.d/worker-fuzzy.inc \
	&& echo 'backend = "sqlite";' >> /etc/rspamd/local.d/worker-fuzzy.inc \
	&& echo 'hashfile = "${DBDIR}/fuzzy.db";' >> /etc/rspamd/local.d/worker-fuzzy.inc \
	&& echo 'expire = 90d;' >> /etc/rspamd/local.d/worker-fuzzy.inc \
	&& echo 'allow_update = ["127.0.0.1", "::1"];' >> /etc/rspamd/local.d/worker-fuzzy.inc \
	&& echo 'enabled = false;' > /etc/rspamd/local.d/worker-normal.inc \
	&& echo 'upstream "local" {' > /etc/rspamd/local.d/worker-proxy.inc \
	&& echo '  self_scan = yes;' >> /etc/rspamd/local.d/worker-proxy.inc \
	&& echo '}' >> /etc/rspamd/local.d/worker-proxy.inc \
	&& echo 'selector_map = "/var/lib/rspamd/dkim/dkim_selectors.map";' >> /etc/rspamd/local.d/dkim_signing.conf \
	&& echo 'bind_socket = "*:11332";' >> /etc/rspamd/local.d/worker-proxy.inc \
	&& echo 'password = "";' > /etc/rspamd/local.d/worker-controller.inc \
	&& echo 'enable_password = "";' >> /etc/rspamd/local.d/worker-controller.inc

COPY ./entrypoint.sh /
ENTRYPOINT [ "tini", "--", "./entrypoint.sh" ]
CMD	[ "rspamd", "-f", "-u", "mail", "-g", "mail" ]

EXPOSE	11333/tcp 11334/tcp
