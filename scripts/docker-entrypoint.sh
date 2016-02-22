#!/bin/bash
set -e
#change elasticsearch
sed -ri "s!^(\#\s*)?(elasticsearch_url:).*!\2 '$ELASTICSEARCH_URL'!" /var/www/kibana/config/kibana.yml

# start nginx
service nginx restart

# start kibana
exec kibana
exec "$@"
