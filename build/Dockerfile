ARG  ALPINE_IMAGE="alpine:latest"
FROM ${ALPINE_IMAGE}

RUN apk add --no-cache \
      bash \
      shadow \
      sudo \
      bash-completion \
      tzdata \
      supervisor \
      vim \
      netcat-openbsd \
      iproute2 \
      openssh \
      openssl \
      tree \
      rsync \
      curl \
      tar \
      dcron \
      util-linux-misc \
      binutils \
      gnupg \
      perl-net-ssleay

RUN apk add swaks --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/

RUN ln -sf /usr/bin/vim /usr/bin/vi ; ln -sf /usr/bin/nc /usr/bin/netcat
RUN chmod u+s /sbin/ss

RUN sed -i "s/#PermitRootLogin.*/PermitRootLogin no/"                   /etc/ssh/sshd_config
RUN sed -i "s/#PasswordAuthentication.*/PasswordAuthentication no/"     /etc/ssh/sshd_config
RUN sed -i "s/AllowTcpForwarding no/AllowTcpForwarding yes/"            /etc/ssh/sshd_config
RUN sed -i "s/#AllowAgentForwarding.*/AllowAgentForwarding yes/"        /etc/ssh/sshd_config
RUN sed -i "s/GatewayPorts.*/GatewayPorts clientspecified/"             /etc/ssh/sshd_config
RUN sed -i "s/#ClientAliveInterval.*/ClientAliveInterval 30/"           /etc/ssh/sshd_config
RUN sed -i "s/#ClientAliveCountMax.*/ClientAliveCountMax 3/"            /etc/ssh/sshd_config
RUN echo   'Include /etc/ssh/sshd_config.d/*.conf'                   >> /etc/ssh/sshd_config
RUN mkdir -p /etc/ssh/sshd_config.d && chmod 755                        /etc/ssh/sshd_config.d

RUN sed -i "s/#.Host.*/Host \*/"			                /etc/ssh/ssh_config
RUN sed -i "s/#.*ForwardAgent.*/    ForwardAgent yes/"	                /etc/ssh/ssh_config

RUN sed -i "s#\/bin\/ash#/bin/bash#g" /etc/passwd

RUN rm -f /etc/motd

COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN   mkdir -p     /usr/local/bin
COPY  ./bin/*      /usr/local/bin/
RUN   chmod -R a+x /usr/local/bin
COPY  ./boot.d     /boot.d
RUN   chmod -R 700 /boot.d
COPY  conf.d/etc/ /etc/
RUN   chmod u+s /bin/ping /usr/bin/traceroute
COPY ./motd.sh /etc/profile.d/
RUN  chmod a+x /etc/profile.d/motd.sh
COPY ./users.header /etc/
COPY ./users.init   /etc/
RUN  chmod 222 /etc/users.header /etc/users.init
COPY ./templates /templates

EXPOSE      22

#
# startup script
#
ADD ./start.sh /start.sh
RUN chmod 755 /start.sh
CMD ["/start.sh"]

