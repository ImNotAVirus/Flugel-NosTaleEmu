#
# DON'T use this Dockerfile on production !!!
# There are probably some security issues
#
# Use it only for test your app and his deployment method (edeliver)
#

FROM debian:9.8
LABEL maintainer="ImNotAVirus https://github.com/ImNotAVirus"

RUN apt-get update && \
    apt-get install -y locales openssh-server git wget gnupg && \
    wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && \
    dpkg -i erlang-solutions_1.0_all.deb && \
    apt-get update && \
    apt-get install -y esl-erlang elixir && \
    apt-get clean && \
    useradd -ms /bin/bash deploy && \
    mkdir -p /var/run/sshd && \
    export LANG=en_US.UTF-8 \
    && echo $LANG UTF-8 > /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=$LANG

# USER deploy
WORKDIR /home/deploy

COPY id_rsa.pub .ssh/authorized_keys

EXPOSE 22

ENTRYPOINT ["/usr/sbin/sshd"]
CMD ["-D"]
