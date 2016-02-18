FROM kibana:4.0.3


COPY kibana.yml /opt/kibana/config/kibana.yml
COPY kibana /etc/init.d/kibana
RUN chmod +x /etc/init.d/kibana \
 && update-rc.d kibana defaults 96 9 

COPY init.sh /
RUN chmod +x /init.sh
ENTRYPOINT ["/init.sh"]
 


