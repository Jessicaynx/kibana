FROM kibana:4.0.3
MAINTAINER Jessica Liu

# Install htpasswd utility and curl
RUN apt-get update \
    && apt-get install -y curl apache2-utils zip vim nginx \
    && rm -rf /etc/nginx/conf.d/* \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# Copy Nginx config
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/kibana.conf /etc/nginx/conf.d/kibana.conf

# Add default credentials
RUN htpasswd -cb /etc/nginx/.htpasswd kibana "docker"




