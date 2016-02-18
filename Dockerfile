FROM nginx:1.7
MAINTAINER Helder Correia <heldercorreia@morfose.net>

# Install htpasswd utility and curl
RUN apt-get update \
    && apt-get install -y curl apache2-utils netcat\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

FROM kibana:4.0.3

# Add default credentials
RUN htpasswd -cb /etc/nginx/.htpasswd kibana "docker"

# Copy Nginx config
COPY nginx.conf /etc/nginx/nginx.conf
COPY kibana.conf /etc/nginx/conf.d/kibana.conf
COPY kibana.yml /var/www/kibana/config/kibana.yml
COPY kibana /etc/init.d/kibana
RUN chmod +x /etc/init.d/kibana \
 && update-rc.d kibana defaults 96 9 \
 && service kibana start \

COPY init.sh /
RUN chmod +x /init.sh
ENTRYPOINT ["/init.sh"]
 
# Run nginx
CMD ["nginx", "-g", "daemon off;"]
RUN service nginx start 

