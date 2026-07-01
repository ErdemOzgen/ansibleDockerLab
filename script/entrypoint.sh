#!/bin/sh
set -eu

mkdir -p /run/sshd /var/run/sshd
ssh-keygen -A

if [ -f /run/nologin ]; then
	rm -f /run/nologin
fi

exec "$@"
