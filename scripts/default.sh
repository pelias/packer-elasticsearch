#!/bin/bash -ex

export DEBIAN_FRONTEND=noninteractive

# https://github.com/hashicorp/packer/issues/41
sleep 30

# 'DEBIAN_FRONTEND=noninteractive' is specified again for sudo
# this resolved an issue with 'grub-pc' pausing for interactive input
# the solution was suggested in a comment here, and sucessfully disables the interactive prompt:
# https://askubuntu.com/questions/146921/how-do-i-apt-get-y-dist-upgrade-without-a-grub-config-prompt
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

sudo chmod 777 /var/cache/debconf/
sudo chmod 777 /var/cache/debconf/passwords.dat
echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

sudo apt-get install htop dstat jq awscli -y

echo "elasticsearch soft nofile 128000
elasticsearch hard nofile 128000
elasticsearch soft memlock unlimited
elasticsearch hard memlock unlimited
root soft nofile 128000
root hard nofile 128000" | sudo tee --append /etc/security/limits.conf

echo "fs.file-max = 500000" | sudo tee --append /etc/sysctl.conf

# move udev rules and related scripts to the proper place
sudo mv /tmp/ebsnvme-id /sbin
sudo mv /tmp/ec2udev-vbd /sbin
sudo chown root:root /sbin/ebsnvme-id /sbin/ec2udev-vbd
sudo chmod u+x /sbin/ebsnvme-id /sbin/ec2udev-vbd
sudo chmod go-rwx /sbin/ebsnvme-id /sbin/ec2udev-vbd
sudo mv /tmp/10-aws.rules /etc/udev/rules.d
