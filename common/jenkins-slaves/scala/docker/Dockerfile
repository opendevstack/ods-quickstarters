FROM opendevstackorg/ods-jenkins-slave-base-centos7

LABEL maintainer="Jan Frank <jan.frank@boehringer-ingelheim.com>"

ARG nexusUrl
ARG nexusUsername
ARG nexusPassword

ENV SBT_VERSION=1.3.12
ENV SBT_CREDENTIALS="$HOME/.sbt/.credentials"

RUN yum -y install java-1.8.0-openjdk-devel \
    && alternatives --set java $(alternatives --display java | awk '/family.*x86_64/ { print $1; }')

RUN curl -O -L http://dl.bintray.com/sbt/rpm/sbt-$SBT_VERSION.rpm && \
    yum -y install sbt-$SBT_VERSION.rpm && \
    yum clean all && \
    rm -rf /var/cache/yum

COPY sbtconfig/repositories $HOME/.sbt/repositories
COPY sbtconfig/credentials.sbt $HOME/.sbt/1.0/plugins/credentials.sbt
COPY sbtconfig/credentials $HOME/.sbt/.credentials
COPY sbtconfig/sbtopts /etc/sbt/sbtopts
COPY set_sbt_proxy.sh /tmp/set_sbt_proxy.sh

RUN cat $HOME/.sbt/repositories | sed -e "s|NEXUS_URL|$nexusUrl|g" > $HOME/.sbt/repositories.tmp && \
    mv $HOME/.sbt/repositories.tmp $HOME/.sbt/repositories  && \
    nexusHost=$(echo $nexusUrl | sed -e "s|https://||g" | sed -e "s|http://||g") && \
    nexusHost=$(echo $nexusHost | sed -e "s|:.*||g") && \
    sed -i.bak -e "s|NEXUS_HOST|$nexusHost|g" $HOME/.sbt/.credentials && \
    sed -i.bak -e "s|NEXUS_USERNAME|$nexusUsername|g" $HOME/.sbt/.credentials && \
    sed -i.bak -e "s|NEXUS_PASSWORD|$nexusPassword|g" $HOME/.sbt/.credentials && \
    rm $HOME/.sbt/.credentials.bak && \
    cd /tmp && \
    /tmp/set_sbt_proxy.sh

RUN sbt new scala/scala-seed.g8 --name="scala-test" && \
    cd scala-test && \
    sbt test && \
    rm -rf /tmp/scala-test /tmp/target

RUN	\
    chgrp -R 0 $HOME && \
    chmod -R 777 $HOME && \
	chown -R 1001 $HOME

USER 1001
