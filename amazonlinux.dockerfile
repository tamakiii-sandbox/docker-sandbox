FROM amazonlinux:2018.03.0.20180827 as mainline

RUN yum update -y

# --

FROM mainline AS base

RUN yum update -y && \
    yum install -y \
      make \
      && \
   yum clean all && \
   rm -rf /var/cache/yum

# --
