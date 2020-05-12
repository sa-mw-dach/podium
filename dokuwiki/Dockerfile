# This Dockerfile prepares a generic dokuwiki image with the gitbacked plugin for GIT integration
FROM quay.io/podium/dokuwiki:latest
  

ADD https://github.com/woolfg/dokuwiki-plugin-gitbacked/archive/master.zip /tmp/gitbacked.zip


RUN \
        unzip -d lib/plugins/ /tmp/gitbacked.zip && \
        mv lib/plugins/dokuwiki-plugin-gitbacked-master/ lib/plugins/gitbacked && \
        rm -f /tmp/gitbacked.zip

