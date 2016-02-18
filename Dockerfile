FROM kibana:4.0.3
MAINTAINER Jessica Liu

# Update the repository
RUN apt-get update
# Install necessary tools
RUN apt-get install -y vim wget dialog net-tools

# Download and Install Nginx
RUN apt-get install -y nginx httpd-tools


# Add default credentials
RUN htpasswd -cb /etc/nginx/.htpasswd kibana "docker"

# Copy Nginx config
COPY nginx.conf /etc/nginx/nginx.conf
COPY kibana.conf /etc/nginx/conf.d/kibana.conf
COPY kibana.yml /var/www/kibana/config/kibana.yml
COPY kibana /etc/init.d/kibana
RUN chmod +x /etc/init.d/kibana \
 && update-rc.d kibana defaults 96 9

# Expose ports
EXPOSE 80

# Set wrapper for runtime config
COPY init.sh /
RUN chmod +x /init.sh
ENTRYPOINT ["/init.sh"]

# Run nginx
CMD ["nginx", "-g", "daemon off;"]

CMD service kibana start 
CMD service nginx start 
