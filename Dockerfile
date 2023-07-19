FROM ubuntu:18.04

ENV SPARK_VERSION=3.2.4
ENV HADOOP_VERSION=3.2.4

WORKDIR /root/docker
COPY * ./
RUN cd /root/docker && cp ./* /usr/local/ && cd /usr/local/ && tar -zxvf jdk-8u371-linux-x64.tar.gz && mv jdk1.8.0_371 jdk \
 && tar -zxvf hadoop-3.2.4.tar.gz &&  tar -zxvf spark-3.2.4-bin-hadoop3.2.tgz && rm hadoop-3.2.4.tar.gz jdk-8u371-linux-x64.tar.gz spark-3.2.4-bin-hadoop3.2.tgz \
 && mv -f hdfs-site.xml /usr/local/hadoop-3.2.4/etc/hadoop/ && mv -f hadoop-env.sh /usr/local/hadoop-3.2.4/etc/hadoop/ && mv -f core-site.xml /usr/local/hadoop-3.2.4/etc/hadoop/ \
 && hadoop-3.2.4/bin/hdfs namenode -format && mv -f  spark-env.sh /usr/local/spark-3.2.4-bin-hadoop3.2/conf/
#
RUN apt-get update -y && apt-get install openssh-server openssh-client pdsh -y \
  && ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa \
  && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
  && chmod 0600 ~/.ssh/authorized_keys \
  && pdsh -q -w localhost \
  && export PDSH_RCMD_TYPE=ssh \
  && /etc/init.d/ssh start

ENV JAVA_HOME /usr/local/jkd
ENV PATH $PATH:$JAVA_HOME/bin
ENV HADOOP_HOME /usr/local/hadoop-3.2.4
ENV SPARK_HOME /usr/local/spark-3.2.4-bin-hadoop3.2
#CMD [ "sh", "/etc/init.d/ssh", "start"]

#docker build -t spark-hadoop:1 .
#docker run -dit --name spark spark-hadoop:1
#docker exec -it spark /bin/bash
