#!/usr/bin/dumb-init /bin/sh
set -e
create_gitlab_user_ssh_key.sh
set -- docker-entrypoint-original.sh "$@"
exec "$@"
