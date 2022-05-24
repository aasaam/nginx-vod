#!/bin/bash
set -e
envsubst < /opt/kaltura/nginx/templates/nginx.conf > /opt/kaltura/nginx/conf/nginx.conf
exec "$@"
