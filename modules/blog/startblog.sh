#!/bin/bash

mkdir -p /mnt/efs
chown ec2-user:ec2-user /mnt/efs

# update /etc/fstab

#  - echo "$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone).${file_system_id}.efs.$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | head -c-1).amazonaws.com:/ /mnt/efs nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 0 0" >> /etc/fstab


# mount fs
# mount -a -t nfs4


env
env>/tmp/env.txt
cat /etc/hostname
cp /etc/hostname /tmp/hostname.txt

# copy hugo locally

# execute hugo as ec2-user?
