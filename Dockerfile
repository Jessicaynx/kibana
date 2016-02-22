FROM nginx:1.7
MAINTAINER Helder Correia <heldercorreia@morfose.net>

# Install htpasswd utility and curl
RUN apt-get update \
    && apt-get install -y curl apache2-utils \
    && rm -rf /etc/nginx/conf.d/* \
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
RUN update-rc.d kibana defaults 96 9 

#add startup scirpts
#using cmd to copy/update configuration files and keys from aws S3 
#and then start the service
ADD scripts/startup_scripts  /usr/local/bin/startup_scripts
RUN chmod +111 /usr/local/bin/startup_scripts

EXPOSE 5601

CMD ["/usr/local/bin/startup_scripts"]

