#!/bin/bash
set -e
envsubst "$(env | sed -e 's/=.*//' -e 's/^/\$/g')" < /opt/kaltura/nginx/templates/nginx.conf > /opt/kaltura/nginx/conf/nginx.conf
exec "$@"
