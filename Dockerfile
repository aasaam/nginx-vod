# Copyright(c) 2022 aasaam software development group
FROM ubuntu:20.04 as builder

RUN export DEBIAN_FRONTEND=noninteractive; \
  apt update && \
  apt upgrade -y && \
  apt install wget gnupg2 gettext-base --no-install-recommends -y && \
  wget -O - http://installrepo.kaltura.org/repo/aptn/focal/kaltura-deb-256.gpg.key | apt-key add - && \
  echo "deb [arch=amd64] http://installrepo.kaltura.org/repo/aptn/focal quasar main" > /etc/apt/sources.list.d/kaltura.list && \
  apt update && \
  apt install kaltura-nginx libxml2 --no-install-recommends -y && \
  apt-get -y purge wget gnupg2 && \
  apt-get autoremove -y && \
  rm -rf /var/lib/apt/lists/* && rm -rf /tmp && mkdir /tmp && chmod 777 /tmp && \
  rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
  rm -rf /usr/lib/python* && \
  export FFMPEG_PATH=$(realpath /opt/kaltura/ffmpeg-*); \
  rm -rf /opt/kaltura/bin && \
  rm -rf /opt/kaltura/log && \
  rm -rf /opt/kaltura/nginx/html && \
  rm -rf /opt/kaltura/nginx/logs && \
  rm -rf /opt/kaltura/nginx/static && \
  rm -rf /opt/kaltura/nginx/conf && \
  rm -rf $FFMPEG_PATH/share && \
  rm -rf $FFMPEG_PATH/include && \
  mkdir -p /opt/kaltura/log/nginx && \
  mkdir -p /opt/kaltura/nginx/logs && \
  chmod 777 /opt/kaltura/nginx/logs && \
  chmod 777 /opt/kaltura/log/nginx && \
  ldconfig && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && rm -rf /tmp && mkdir /tmp && chmod 777 /tmp && truncate -s 0 /var/log/*.log

EXPOSE 80
STOPSIGNAL SIGTERM
# default nginx.conf
ADD nginx/nginx.conf /opt/kaltura/nginx/conf/nginx.conf

# conf.d
ADD nginx/conf.d /opt/kaltura/nginx/conf.d

# template
ADD nginx/templates /opt/kaltura/nginx/templates
ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["/opt/kaltura/nginx/sbin/nginx", "-g", "daemon off;"]
