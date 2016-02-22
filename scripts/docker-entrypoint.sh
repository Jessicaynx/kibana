#!/bin/bash

set -e
sed -ri "s!^(\#\s*)?(elasticsearch_url:).*!\2 '$ELASTICSEARCH_URL'!" /var/www/kibana/config/kibana.yml
exec "$@"
