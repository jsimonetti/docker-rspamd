FROM jsimonetti/alpine-edge

RUN	apk add --no-cache rspamd rspamd-controller rspamd-proxy rspamd-fuzzy

RUN	echo 'type = "console";' > /etc/rspamd/override.d/logging.inc \
	&& echo 'bind_socket = "*:11334";' > /etc/rspamd/override.d/worker-controller.inc \
	&& echo 'pidfile = false;' > /etc/rspamd/override.d/options.inc

CMD	[ "/usr/sbin/rspamd", "-f", "-u", "mail", "-g", "mail" ]

EXPOSE	11333/tcp 11334/tcp
