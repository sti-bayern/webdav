FROM ubuntu:trusty

LABEL maintainer="Günther Morhart"

#
# Build variables
#
ARG ID=1000

#
# Environment variabless
#
ENV USERNAME=buffy
ENV PASSWORD=test


RUN apt-get update && apt-get install -y nginx nginx-extras apache2-utils openssl

RUN groupadd --gid $ID app && \
    useradd -u $ID -g app -s /bin/bash app -p $(echo app | openssl passwd -1 -stdin) && \
    mkdir /app &&  chown -R app:app /app

EXPOSE 80
COPY webdav.conf /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/*

COPY entrypoint.sh /
RUN chmod +x entrypoint.sh
CMD /entrypoint.sh && nginx -g "daemon off;"