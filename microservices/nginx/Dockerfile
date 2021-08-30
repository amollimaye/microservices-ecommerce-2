FROM nginx

RUN apt-get update \
	&& apt-get install -y -q wget curl unzip lsb-release runit

# https://releases.hashicorp.com/consul-template/0.19.5/
ARG CONSUL_TEMPLATE_VERSION=0.19.5
ENV CT_URL https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip
RUN curl -O $CT_URL
RUN unzip consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip -d /usr/local/bin

ADD nginx.service /etc/service/nginx/run
ADD consul-template.service /etc/service/consul-template/run
RUN chmod +x /etc/service/nginx/run
RUN chmod +x /etc/service/consul-template/run

RUN rm -v /etc/nginx/conf.d/*
ADD nginx.conf /etc/consul-templates/nginx.conf
ADD index.html /etc/consul-templates/index.html

CMD ["/usr/bin/runsvdir", "/etc/service"]