# Version 0.0.1
# author: lihan@migu.cn
# docker build .  -t dispsql:v0.0.1

# 基础镜像
FROM centos:latest

# 维护者信息
MAINTAINER lihan@migu.cn

# Add Citus repository for package manager
RUN curl https://install.citusdata.com/community/rpm.sh |  bash

# install Citus extension
RUN yum install -y citus82_11

ADD run.sh .

USER postgres

CMD chmod +x ./run.sh

# 容器启动命令
CMD /bin/bash  -c "./run.sh"