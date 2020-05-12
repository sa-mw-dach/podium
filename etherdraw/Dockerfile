FROM node:current-alpine
MAINTAINER Sebastian Hetze <shetze@redhat.com>

RUN apk update; apk add bash git giflib-dev libjpeg-turbo-dev curl mysql-client python2 pkgconfig cairo-dev pango-dev make g++

WORKDIR /opt/

RUN git clone git://github.com/shetze/draw.git

ENV PYTHON=/usr/bin/python2

WORKDIR draw

RUN bin/installDeps.sh

RUN addgroup -g 1001 etherdraw \
    && adduser -h /opt/draw -SD -G etherdraw -u 1001 etherdraw \
    && touch /opt/draw/var/dirty.db \
    && chmod 777 /opt/draw/var/dirty.db \
    && chown -R etherdraw.etherdraw /opt/draw

USER 1001
EXPOSE 9002
ENTRYPOINT ["node", "/opt/draw/server.js"]
