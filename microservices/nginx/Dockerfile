FROM nginx:latest

RUN apt-get update \
    && apt-get install -y -q wget curl unzip lsb-release runit \
    && rm -rf /var/lib/apt/lists/*

# Download and install Consul Template
ARG CONSUL_TEMPLATE_VERSION=0.29.1
RUN curl -fsSL https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip \
    -o /tmp/consul-template.zip && \
    unzip /tmp/consul-template.zip -d /usr/local/bin && \
    rm /tmp/consul-template.zip && \
    chmod +x /usr/local/bin/consul-template

# Create service directories
RUN mkdir -p /etc/service/nginx /etc/service/consul-template /etc/consul-templates

# Add service scripts
ADD nginx.service /etc/service/nginx/run
ADD consul-template.service /etc/service/consul-template/run
RUN chmod +x /etc/service/nginx/run /etc/service/consul-template/run

# Remove default nginx config
RUN rm -f /etc/nginx/conf.d/default.conf

# Add templates
ADD nginx.conf /etc/consul-templates/nginx.conf
ADD index.html /etc/consul-templates/index.html

EXPOSE 8080

CMD ["/usr/bin/runsvdir", "/etc/service"]
