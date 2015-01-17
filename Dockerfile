FROM ifunsoftware/c3-base
#jetty

# Install packages
RUN apt-get update && \
    apt-get update --fix-missing && \
    apt-get install -y wget

RUN apt-get install lsof

# Download and install jetty
ENV jetty_dist jetty-distribution-9.2.6.v20141205
RUN echo "installing jetty $jetty_dist "
RUN wget http://download.eclipse.org/jetty/stable-9/dist/$jetty_dist.tar.gz && \
    tar -xzvf $jetty_dist.tar.gz

RUN rm -rf $jetty_dist.tar.gz && \
    mv $jetty_dist /opt/jetty

# Configure Jetty user and clean up install
RUN useradd jetty && \
    chown -R jetty:jetty /opt/jetty && \
    rm -rf /opt/jetty/webapps.demo

# Get c3-web war
#RUN wget 'http://repository.ifunsoftware.com/service/local/artifact/maven/redirect?r=snapshots&g=org.aphreet.c3&a=c3webclient&p=war&v=LATEST' --content-disposition
#webapps ls -la
#RUN cp c3webclient*.war /opt/jetty/webapps
#COPY c3webclient*.war /opt/jetty/webapps/root.war


# Set defaults for docker run
# WORKDIR /opt/jetty
# CMD ["java", "-jar", "start.jar", "jetty.home=/opt/jetty"]


# Add services configuration for supervisor
COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Configure 'c3-web' service startup in supervisor
COPY conf/start_c3-web.sh /usr/bin/start_c3-web.sh
RUN chmod +x /usr/bin/start_c3-web.sh


EXPOSE 22 8080 8443

