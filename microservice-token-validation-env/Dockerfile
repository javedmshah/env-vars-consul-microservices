FROM forgerock-docker-public.bintray.io/microservice/token-validation:BASE-ONLY

MAINTAINER Javed Shah <javed.shah@forgerock.com>

COPY envconsul /usr/bin/ 

ADD envconsul.sh /usr/bin/envconsul.sh
RUN chmod +x /usr/bin/envconsul.sh

ENTRYPOINT ["/usr/bin/envconsul.sh"]
