FROM nginx:1.7
MAINTAINER Jessica Liu

# Install htpasswd utility and curl
RUN apt-get update \
    && apt-get install -y curl apache2-utils zip\
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

#install python2.7
RUN apt-get update -y
RUN apt-get install -y python2.7
RUN ln -s /usr/bin/python2.7 /usr/bin/python

#install amazon AWS CLI
RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
RUN unzip awscli-bundle.zip
RUN ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
RUN rm awscli-bundle.zip

#add startup scirpts
#using cmd to copy/update configuration files and keys from aws S3 
#and then start the service
ADD scripts/startup_scripts  /usr/local/bin/startup_scripts
RUN chmod +111 /usr/local/bin/startup_scripts

EXPOSE 5601
CMD ["/usr/local/bin/startup_scripts"]

