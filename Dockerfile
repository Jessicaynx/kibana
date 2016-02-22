FROM nginx:1.7
MAINTAINER Jessica Liu

# Install htpasswd utility and curl
RUN apt-get update \
    && apt-get install -y curl apache2-utils zip vim \
    && rm -rf /etc/nginx/conf.d/* \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Kibana
ENV KIBANA_VERSION 4.0.3
RUN mkdir -p /var/www \
 && curl -s https://download.elasticsearch.org/kibana/kibana/kibana-$KIBANA_VERSION-linux-x64.tar.gz \
  | tar --transform "s/^kibana-$KIBANA_VERSION/kibana/" -xvz -C /var/www \
 && mv /var/www/kibana-linux-x64 /var/www/kibana

# Copy Nginx config
COPY nginx.conf /etc/nginx/nginx.conf
COPY kibana.conf /etc/nginx/conf.d/kibana.conf

# Add default credentials
RUN htpasswd -cb /etc/nginx/.htpasswd kibana "docker"

#add startup scirpts
#using cmd to copy/update configuration files and keys from aws S3 
#and then start the service
ADD scripts/startup_scripts  /usr/local/bin/startup_scripts
RUN chmod +x /usr/local/bin/startup_scripts

EXPOSE 5601
CMD ["/usr/local/bin/startup_scripts"]

