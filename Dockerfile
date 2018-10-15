FROM dockerbarbarians/gpl-free-base-image:latest

ENV HADOOP_USER=hadoop \
    HADOOP_LOG_DIR=/var/log/hadoop \
    JAVA_HOME=/opt/java8/jdk-8u181-ojdkbuild-linux-x64 \
    HADOOP_HOME=/opt/barbarian/hadoop \
    HADOOP_INSTALL=/opt/barbarian/hadoop \
    HADOOP_COMMON_HOME=/opt/barbarian/hadoop/share/hadoop/common \
    HADOOP_YARN_HOME=/opt/barbarian/hadoop/share/hadoop/yarn \
    YARN_HOME=/opt/barbarian/hadoop/share/hadoop/yarn \
    IGNITE_HOME=/opt/barbarian/ignite \
    IGNITE_CONF_DIR=/opt/barbarian/ignite/config \
    HADOOP_MAPRED_HOME=/opt/barbarian/hadoop/share/hadoop/mapreduce \
    HADOOP_HDFS_HOME=/opt/barbarian/hadoop/share/hadoop/hdfs \
    HADOOP_PREFIX=/opt/barbarian/hadoop \
    HADOOP_CONF_DIR=/opt/barbarian/hadoop/etc/hadoop \
    YARN_CONF_DIR=/opt/barbarian/hadoop/etc/hadoop \
    HADOOP_CLASSPATH=/opt/barbarian/hadoop/share/hadoop/hdfs/*:/opt/barbarian/hadoop/share/hadoop/hdfs/lib/*:/opt/barbarian/hadoop/share/hadoop/yarn/timelineservice/*:/opt/barbarian/hadoop/share/hadoop/yarn/timelineservice/lib/*:/opt/barbarian/ignite/config:/opt/barbarian/hadoop/etc/hadoop:/opt/barbarian/hadoop/share/hadoop/common/lib/*:/opt/barbarian/hadoop/share/hadoop/common/*:/opt/barbarian/hadoop/share/hadoop/yarn/*:/opt/barbarian/hadoop/share/hadoop/yarn/lib/*:/opt/barbarian/tez/conf:/opt/barbarian/hive/lib/*:/opt/barbarian/tez/lib/*:/opt/barbarian/tez/* \
    CONTROL_HOME=/opt/barbarian/control \
    HADOOP_HEAPSIZE=2g \
    LD_LIBRARY_PATH=/opt/bash/usr/lib \
    IGNITE_CUSTOM_CLASSPATH=/opt/barbarian/ignite/config:/opt/barbarian/hadoop/share/hadoop/common/lib/*:/opt/barbarian/hadoop/share/hadoop/common/*:/opt/barbarian/hadoop/share/hadoop/tools/*:/opt/barbarian/hadoop/share/hadoop/tools/lib/* \
    LLAP_DAEMON_USER_CLASSPATH=/opt/barbarian/hadoop/share/hadoop/yarn/*:/opt/barbarian/hadoop/share/hadoop/yarn/lib/*

RUN ln -s /opt/python27/bin/python /usr/bin/python
RUN mkdir -p /opt/barbarian
RUN mkdir -p /etc/hadoop
RUN mkdir -p /opt/barbarian/ignite/libs

COPY ./opt/barbarian/control /opt/barbarian/control
COPY ./opt/barbarian/hadoop /opt/barbarian/hadoop
COPY ./opt/barbarian/ignite/libs/ignite-*.jar /opt/barbarian/hadoop/share/hadoop/common/lib/
COPY ./opt/barbarian/ignite/libs/ignite-*.jar /opt/barbarian/ignite/libs/
COPY ./opt/barbarian/ignite/libs/ignite-hadoop/ignite-*.jar /opt/barbarian/hadoop/share/hadoop/common/lib/
COPY ./opt/barbarian/ignite/libs/ignite-hadoop/ignite-*.jar /opt/barbarian/ignite/libs/
COPY ./getdomainname /opt/barbarian/control/getdomainname

RUN ln -s /opt/barbarian/control/basename /usr/bin/basename
RUN ln -s /opt/barbarian/control/which /usr/bin/which
RUN ln -s /opt/barbarian/control/readlink /usr/bin/readlink
RUN ln -s /opt/barbarian/control/regex_match /usr/bin/regex_match
RUN ln -s /opt/barbarian/control/mktemp /usr/bin/mktemp
RUN rm -f /usr/bin/hostname
RUN ln -s /opt/barbarian/control/hostname /usr/bin/hostname
RUN ln -s /usr/bin/nawk /usr/bin/awk
RUN ln -s /opt/barbarian/control/getdomainname /usr/bin/getdomainname

RUN chmod +x /usr/bin/getdomainname

RUN mkdir -p /opt/java8
RUN mkdir -p /opt/glibc

RUN mkdir -p /lib64
RUN ln -s /opt/glibc/usr/glibc-compat/lib/ld-linux-x86-64.so.2 /lib/ld-linux-x86-64.so.2
RUN ln -s /opt/glibc/usr/glibc-compat/lib/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2
RUN ln -s /opt/glibc/usr/glibc-compat /usr/glibc-compat

RUN echo "$HADOOP_USER:!::1000:::::" >> /etc/shadow
RUN echo "$HADOOP_USER:!::1000:::::" >> /etc/shadow
RUN echo "$HADOOP_USER:x:1000:$HADOOP_USER" >> /etc/group
RUN echo "$HADOOP_USER:x:1000:1000:$HADOOP_USER:/opt/barbarian:/bin/mksh" >> /etc/passwd

RUN ln -s /opt/glibc/usr/glibc-compat/etc/ld.so.cache /etc/ld.so.cache
RUN ln -s /opt/glibc/usr/glibc-compat/etc/ld.so.conf /etc/ld.so.conf

# GNU bash is a mandatory prerequisite for Hadoop 3.x
RUN mkdir -p /opt/bash
RUN ln -s /opt/bash/bin/bash /bin/bash
RUN ln -s /opt/bash/usr/lib/libncursesw.so.6 /usr/lib/libncursesw.so.6
RUN ln -s /opt/bash/usr/lib/libncursesw.so.6 /usr/lib/libncursesw.so.6.0
RUN ln -s /opt/bash/usr/lib/libreadline.so.6 /usr/lib/libreadline.so.6
RUN ln -s /opt/bash/usr/lib/libreadline.so.6 /usr/lib/libreadline.so.6.3

# Hadoop hardcodes the mv coretool to /bin/mv
RUN ln -s /usr/bin/mv /bin/mv

RUN echo "set backspace=indent,eol,start" > /opt/barbarian/.vimrc
RUN echo "set number" >> /opt/barbarian/.vimrc
RUN echo "syntax on" >> /opt/barbarian/.vimrc

RUN echo 'hosts: files mdns4_minimal dns mdns4' > /etc/nsswitch.conf

# dynamically downloading and installing glibc and java at pod initialization time means that 
# some system paths need to either belong to the hadoop user, or the hadoop user needs to be root.
# by relocating the paths to /opt and symlinking, we can limit any privilege escalation somewhat.
RUN mkdir -p $HADOOP_LOG_DIR \
    && mkdir -p /grid/0 \
    && chown -R $HADOOP_USER /opt/barbarian \
    && chown -R $HADOOP_USER /opt/bash \
    && chown -R $HADOOP_USER /grid \
    && chown -R $HADOOP_USER /opt/java8 \
    && chown -R $HADOOP_USER /opt/glibc \
    && chown -R $HADOOP_USER /opt/python27 \
    && chown -R $HADOOP_USER $HADOOP_LOG_DIR \
    && ln -s /opt/barbarian/hadoop/etc/hadoop /etc/hadoop/conf \
    && chgrp -R $HADOOP_USER /grid \
    && chmod -R 0755 /grid

