#!/bin/bash

#change elasticsearch
sed -ri "s!^(\#\s*)?(elasticsearch_url:).*!\2 '$ELASTICSEARCH_URL'!" /var/www/kibana/config/kibana.yml

# start nginx
service nginx start
