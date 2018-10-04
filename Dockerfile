FROM dockerbarbarians/gpl-free-base-image:latest

ENV HADOOP_USER=hadoop \
    HADOOP_LOG_DIR=/var/log/hadoop \
    JAVA_HOME=/opt/java8/jdk-8u181-ojdkbuild-linux-x64 \
    HADOOP_HOME=/opt/barbarian/hadoop \
    HADOOP_COMMON_HOME=/opt/barbarian/hadoop/share/hadoop/common \
    HADOOP_YARN_HOME=/opt/barbarian/hadoop/share/hadoop/yarn \
    HADOOP_MAPRED_HOME=/opt/barbarian/hadoop/share/hadoop/mapreduce \
    HADOOP_HDFS_HOME=/opt/barbarian/hadoop/share/hadoop/hdfs \
    HADOOP_CONF_DIR=/opt/barbarian/hadoop/etc/hadoop \
    YARN_CONF_DIR=/opt/barbarian/hadoop/etc/hadoop \
    HADOOP_CLASSPATH=/opt/barbarian/hadoop/etc/hadoop:/opt/barbarian/hadoop/share/hadoop/common/lib/*:/opt/barbarian/hadoop/share/hadoop/common/*:/opt/barbarian/hadoop/share/hadoop/yarn/*:/opt/barbarian/hadoop/share/hadoop/yarn/lib/*:/opt/barbarian/tez/conf:/opt/barbarian/hive/lib/*:/opt/barbarian/tez/lib/*:/opt/barbarian/tez/* \
    CONTROL_HOME=/opt/barbarian/control

RUN ln -s /opt/python27/bin/python /usr/bin/python
RUN mkdir -p /opt/barbarian

COPY ./opt/barbarian/control /opt/barbarian/control
COPY ./opt/barbarian/hadoop /opt/barbarian/hadoop
COPY ./opt/barbarian/ignite/libs/ignite-*.jar /opt/barbarian/hadoop/share/hadoop/common/lib/
COPY ./opt/barbarian/ignite/libs/ignite-hadoop/ignite-*.jar /opt/barbarian/hadoop/share/hadoop/common/lib/

RUN ln -s /opt/barbarian/control/basename /usr/bin/basename
RUN ln -s /opt/barbarian/control/which /usr/bin/which
RUN ln -s /opt/barbarian/control/env /usr/bin/env
RUN ln -s /opt/barbarian/control/declare /usr/bin/declare
RUN ln -s /opt/barbarian/control/readlink /usr/bin/readlink

RUN mkdir -p /opt/java8
RUN mkdir -p /opt/glibc

RUN mkdir -p /lib64
RUN ln -s /opt/glibc/usr/glibc-compat/lib/ld-linux-x86-64.so.2 /lib/ld-linux-x86-64.so.2
RUN ln -s /opt/glibc/usr/glibc-compat/lib/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2
RUN ln -s /opt/glibc/usr/glibc-compat /usr/glibc-compat

RUN mkdir -p /etc/profile.d
RUN echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh

RUN echo "$HADOOP_USER:!::1000:::::" >> /etc/shadow
RUN echo "$HADOOP_USER:!::1000:::::" >> /etc/shadow
RUN echo "$HADOOP_USER:x:1000:$HADOOP_USER" >> /etc/group
RUN echo "$HADOOP_USER:x:1000:1000:$HADOOP_USER:/opt/barbarian:/bin/mksh" >> /etc/passwd

RUN ln -s /opt/glibc/usr/glibc-compat/etc/ld.so.cache /etc/ld.so.cache
RUN ln -s /opt/glibc/usr/glibc-compat/etc/ld.so.conf /etc/ld.so.conf

# dynamically downloading and installing glibc and java at pod initialization time means the 
# whole system path needs to either belong to the hadoop user, or the hadoop user needs to be root.
RUN mkdir -p $HADOOP_LOG_DIR \
    && mkdir -p /grid/0 \
    && mkdir -p /home/$HADOOP_USER \
    && chown -R "$HADOOP_USER" /opt/barbarian \
    && chown -R "$HADOOP_USER" /opt/java8 \
    && chown -R "$HADOOP_USER" /opt/glibc \
    && chown -R "$HADOOP_USER" /opt/python27 \
    && ln -s /opt/barbarian/hadoop/etc/hadoop /etc/hadoop

