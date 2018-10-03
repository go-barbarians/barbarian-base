FROM dockerbarbarians/gpl-free-base-image:latest

ENV HADOOP_USER=hadoop \
    HADOOP_LOG_DIR=/var/log/hadoop \
    JAVA_HOME=/opt/jdk8/jdk-8u181-ojdkbuild-linux-x64 \
    HADOOP_HOME=/opt/barbarian/hadoop \
    HADOOP_CONF_DIR=/opt/barbarian/hadoop/etc/hadoop \
    YARN_CONF_DIR=/opt/barbarian/hadoop/etc/hadoop \
    HADOOP_CLASSPATH=/opt/barbarian/hadoop/etc/hadoop:/opt/barbarian/hadoop/share/hadoop/common/lib/*:/opt/barbarian/hadoop/share/hadoop/common/*:/opt/barbarian/hadoop/share/hadoop/yarn/*:/opt/barbarian/hadoop/share/hadoop/yarn/lib/*:/opt/barbarian/tez/conf:/opt/barbarian/hive/lib/*:/opt/barbarian/tez/lib/*:/opt/barbarian/tez/* \
    CONTROL_HOME=/opt/barbarian/control

#RUN apt-get update && \
#    apt-get install -y openjdk-8-jre-headless python2.7 openssl locales ca-certificates-java wget
#RUN apt-get clean && \
#    update-ca-certificates -f && \
#    rm -rf /var/lib/apt/lists/*

#RUN ln -s /usr/bin/python2.7 /usr/bin/python
RUN ln -s /opt/python27/bin/python /usr/bin/python
RUN mkdir -p /opt/barbarian

COPY ./opt/barbarian/control /opt/barbarian/control
COPY ./opt/barbarian/hadoop /opt/barbarian/hadoop
COPY ./opt/barbarian/ignite/libs/ignite-*.jar /opt/barbarian/hadoop/share/hadoop/common/lib/
COPY ./opt/barbarian/ignite/libs/ignite-hadoop/ignite-*.jar /opt/barbarian/hadoop/share/hadoop/common/lib/

RUN ln -s /opt/barbarian/control/basename /usr/bin/basename
RUN ln -s /opt/barbarian/control/dirname /usr/bin/dirname
RUN ln -s /opt/barbarian/control/which /usr/bin/which
RUN ln -s /opt/barbarian/control/env /usr/bin/env

RUN echo "$HADOOP_USER:!::1000:::::" >> /etc/shadow
RUN echo "$HADOOP_USER:!::1000:::::" >> /etc/shadow
RUN echo "$HADOOP_USER:x:1000:$HADOOP_USER" >> /etc/group
RUN echo "$HADOOP_USER:x:1000:1000:$HADOOP_USER:/opt/barbarian:/bin/mksh" >> /etc/passwd

RUN mkdir -p $HADOOP_LOG_DIR \
    && mkdir -p /grid/0 \
    && mkdir -p /home/$HADOOP_USER \
    && chown -R "$HADOOP_USER" $HADOOP_LOG_DIR \
    && chown -R "$HADOOP_USER" /grid/0 \
    && chown -R "$HADOOP_USER" /opt/barbarian \
    && chgrp -R "$HADOOP_USER" $HADOOP_LOG_DIR \
    && chgrp -R "$HADOOP_USER" /grid/0 \
    && chgrp -R "$HADOOP_USER" /home/$HADOOP_USER \
    && ln -s /opt/barbarian/hadoop/etc/hadoop /etc/hadoop

