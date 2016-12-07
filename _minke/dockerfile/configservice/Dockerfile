FROM ibmcom/kitura-ubuntu:latest

EXPOSE 8090

# Create directory for server files
RUN mkdir /configservice

# Create logs folder
RUN mkdir /var/log/configservice

# Install containerpilot and consul-template
RUN apt-get update
RUN apt-get -y install wget tar unzip curl

ENV CONTAINERPILOT_VERSION 2.1.2
ENV CONTAINERPILOT file:///etc/containerpilot.json
ENV CONSUL_TEMPLATE_VERSION 0.16.0

RUN export CP_SHA1=c31333047d58ba09d647d717ae1fc691133db6eb \
    && curl -Lso /tmp/containerpilot.tar.gz \
    "https://github.com/joyent/containerpilot/releases/download/${CONTAINERPILOT_VERSION}/containerpilot-${CONTAINERPILOT_VERSION}.tar.gz" \
    && echo "${CP_SHA1}  /tmp/containerpilot.tar.gz" | sha1sum -c \
    && tar zxf /tmp/containerpilot.tar.gz -C /bin \
    && rm /tmp/containerpilot.tar.gz


RUN wget --no-check-certificate https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_386.zip; \
      unzip consul-template_${CONSUL_TEMPLATE_VERSION}_linux_386.zip; \
      mv ./consul-template /usr/bin/consul-template; \
      rm -rf consul-template_${CONSUL_TEMPLATE_VERSION}_linux_386.zip; \
      rm -rf consul-template

# Add containerpilot config
COPY containerpilot.json /etc/containerpilot.json

# Add consul-template
COPY config.ctmpl /configservice/config.ctmpl

# Copy binary
COPY configserviceApp /configservice/configserviceApp
COPY libCHTTPParser.so /usr/local/lib/libCHTTPParser.so
ENV LD_LIBRARY_PATH /usr/local/lib:${LD_LIBRARY_PATH}

CMD [ "containerpilot", \
      "/configservice/configserviceApp", \
      "/configservice/config.json" ]
