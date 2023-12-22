#ARG TARGETARCH
#ARG TARGETVARIANT

# aliases
FROM quay.io/pypa/manylinux2014_x86_64 as manylinux2014_amd64_
FROM quay.io/pypa/manylinux2014_i686 as manylinux2014_386_
FROM quay.io/pypa/manylinux2014_aarch64 as manylinux2014_arm64_
FROM quay.io/pypa/manylinux2014_armv7l as manylinux2014_arm_v7

# builder
FROM manylinux2014_${TARGETARCH}_
#_${TARGETVARIANT}

#ARG TARGETARCH
#ARG TARGETVARIANT

ARG PYTHON_VERSION=3.12.1

RUN echo "I am building for $TARGETARCH $TARGETVARIANT, Python $PYTHON_VERSION"

WORKDIR /python

# https://stackoverflow.com/questions/65531567/on-centos-how-do-i-build-python-3-9-from-source-while-incorporating-my-openssl
RUN yum update -y \
 && yum groupinstall "Development Tools" -y \
 && yum install openssl11-devel libffi-devel bzip2-devel xz-devel -y \
 && yum install gcc openssl-devel bzip2-devel libffi-devel zlib-devel -y \
 && curl -O https://www.python.org/ftp/python/{$PYTHON_VERSION}/Python-{$PYTHON_VERSION}.tgz \
 && tar -zxvf Python-{$PYTHON_VERSION}.tgz

RUN cd Python-{$PYTHON_VERSION} \
 &&./configure --enable-optimizations --with-lto \
 && make altinstall