FROM ubuntu

MAINTAINER Javed Shah <javed.shah@forgerock.com>

RUN \
  apt-get update && \
  apt-get install -y curl unzip openjdk-8-jre  && \
  curl -L -o ./consul.zip https://releases.hashicorp.com/envconsul/0.7.3/envconsul_0.7.3_linux_amd64.zip && \
  unzip ./consul.zip && \
  cp ./envconsul /usr/bin/ && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* *.gz

ADD envconsul.sh /usr/bin/envconsul.sh
RUN chmod +x /usr/bin/envconsul.sh
WORKDIR /opt/authn-microservice
ADD . /opt/authn-microservice

EXPOSE 8080

ENTRYPOINT ["envconsul.sh"]
