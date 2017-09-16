#! /bin/bash
#
# install_janus.sh
# Copyright (C) 2017 damian <damian@damian-laptop>
#
# Distributed under terms of the MIT license.
#

#exit if any command returns error (set -e)
set -e

sudo apt-get install \
    libmicrohttpd-dev \
    libjansson-dev  \
    libnice-dev  \
    libgnutls-dev  \
    libsofia-sip-ua-dev  \
    libglib2.0-dev  \
    libopus-dev  \
    libogg-dev  \
    libcurl3-gnutls-dev  \
    gengetopt  \
    libtool  \
    autoconf  \
    automake  \
    doxygen  \
    cmake  \
    graphviz  

sudo chmod 777 /usr/src

#--------------------------------------------------------------------------------
#Installing libsrtp
cd /usr/src 
git clone --branch v2.0 https://github.com/cisco/libsrtp
cd libsrtp
./configure --prefix=/usr --enable-openssl && make shared_library && sudo make install

#--------------------------------------------------------------------------------
#Installing usrsctp
cd /usr/src
git clone https://github.com/sctplab/usrsctp
cd usrsctp
mkdir build && cd build && cmake --prefix=/usr .. && make -j`nproc` && sudo make -j`nproc` install

#--------------------------------------------------------------------------------
#Installing libwebsockets
cd /usr/src
git clone git://git.libwebsockets.org/libwebsockets 
cd libwebsockets
mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_C_FLAGS='-fpic' .. && make -j`nproc` && sudo make -j`nproc` install

#--------------------------------------------------------------------------------
#Installing pahomqtt
cd /usr/src
git clone https://github.com/eclipse/paho.mqtt.c.git  pahomqtt
cd pahomqtt
make -j`nproc` && sudo make -j`nproc` install

#--------------------------------------------------------------------------------
#Installing rabbitmqc
cd /usr/src
git clone https://github.com/alanxz/rabbitmq-c rabbitmqc
cd rabbitmqc
git submodule init && git submodule update && mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr .. && make -j`nproc` && sudo make -j`nproc` install

#--------------------------------------------------------------------------------
#Installing janus_gateway
cd /usr/src
git clone https://github.com/meetecho/janus-gateway.git janus_gateway
cd janus_gateway
./autogen.sh && ./configure --prefix=/opt/janus && make -j`nproc` && sudo make -j`nproc` install

#--------------------------------------------------------------------------------
echo -e "=========================================================================================="
echo -e "Janus WebRTC Gateway and its dependencies installed successfully !!!!"
echo -e "=========================================================================================="
#--------------------------------------------------------------------------------
