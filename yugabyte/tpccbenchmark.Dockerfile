FROM registry.redhat.io/ubi8/openjdk-11

VOLUME /tmp-tgz
USER root
ADD https://github.com/yugabyte/tpcc/releases/download/1.4/tpcc.tar.gz /tmp-tgz/tpcc.tar.gz
RUN mkdir -p  /tpccbenchmark && \
    tar -zxvf /tmp-tgz/tpcc.tar.gz -C /tpccbenchmark
USER 1001
WORKDIR /tpccbenchmark/tpcc
ENTRYPOINT /tpccbenchmark/tpcc/tpccbenchmark 