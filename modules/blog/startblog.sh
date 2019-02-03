#!/bin/bash
yum update -y
yum install -y git
mkdir ~/.ssh
ssh-keygen -t rsa -b 4096  -N '' -C root@$HOSTNAME -f ~/.ssh/id_rsa
ssh-keyscan -H github.com > /etc/ssh/ssh_known_hosts
mkdir ~/blog
cd ~/blog
# At this point we need to get the SSH key into Github
# then we can execute -
#      git clone git@github.com:RIMikeC/blog --recursive
HUGO_VERSION=0.53
wget -q -O /tmp/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
 tar -zxvf /tmp/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz -C /usr/local/bin/ hugo
