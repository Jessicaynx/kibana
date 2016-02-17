FROM nginx:1.6.3
# Install htpasswd utility and curl
RUN sudo yum -y install epel-release \
    && sudo yum -y install nginx httpd-tools curl \

# Install Kibana
ENV KIBANA_VERSION 4.0.3
RUN mkdir -p /var/www \
 && curl -s https://download.elasticsearch.org/kibana/kibana/kibana-$KIBANA_VERSION-linux-x64.tar.gz \
  | tar --transform "s/^kibana-$KIBANA_VERSION/kibana/" -xvz -C /var/www

# Add default credentials
RUN sudo htpasswd -c /etc/nginx/htpasswd.users kibanaadmin

# Copy Nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Set wrapper for runtime config
COPY init.sh /init
ENTRYPOINT ["/init"]

# Run nginx
CMD ["nginx", "-g", "daemon off;"]
