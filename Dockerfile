FROM nginx:1.7
MAINTAINER Helder Correia <heldercorreia@morfose.net>

# Install htpasswd utility and curl
RUN apt-get update \
    && apt-get install -y curl apache2-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Kibana
ENV KIBANA_VERSION 4.0.3
RUN mkdir -p /var/www \
 && curl -s https://download.elasticsearch.org/kibana/kibana/kibana-$KIBANA_VERSION-linux-x64.tar.gz \
  | tar --transform "s/^kibana-$KIBANA_VERSION/kibana/" -xvz -C /var/www \
 && mv /var/www/kibana-linux-x64 /var/www/kibana

# Add default credentials
RUN htpasswd -cb /etc/nginx/.htpasswd kibana "docker"

# Copy Nginx config
COPY nginx.conf /etc/nginx/nginx.conf
COPY kibana.conf /etc/nginx/conf.d/kibana.conf
COPY kibana.yml /var/www/kibana/config/kibana.yml
COPY kibana /etc/init.d/kibana
RUN chmod +x /etc/init.d/kibana

EXPOSE 5601
# Set wrapper for runtime config
COPY init.sh /
RUN chmod +x /init.sh
ENTRYPOINT ["/init.sh"]

# Run nginx
CMD ["nginx", "-g", "daemon off;"]

RUN update-rc.d kibana defaults 96 9 \
 && service kibana start \
 && service nginx start 
