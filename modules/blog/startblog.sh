#!/bin/bash

# Get packages, including Git

yum update -y
yum install -y git

# Add Github to known hosts

ssh-keyscan -H github.com > /etc/ssh/ssh_known_hosts

# Get blog content

aws s3 cp s3://nomoreservers/secrets/id_rsa ~/.ssh/id_rsa --region=eu-west-2
chmod 0600 ~/.ssh/id_rsa
git clone --recursive git@github.com:RIMikeC/blog.git ~ec2-user/blog
rm -f ~/.ssh/id_rsa
find ~ec2-user -exec chown ec2-user:ec2-user {} \;

# Grab a specific version of hugo

HUGO_VERSION=0.53
wget -q -O /tmp/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz 
tar -zxvf /tmp/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz -C /usr/local/bin/ hugo

# Start hugo 

su - ec2-user -c ~ec2-user/blog/run-blog

