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

sudo apt-get install htop dstat jq awscli nvme-cli -y

echo "elasticsearch soft nofile 128000
elasticsearch hard nofile 128000
elasticsearch soft memlock unlimited
elasticsearch hard memlock unlimited
root soft nofile 128000
root hard nofile 128000" | sudo tee --append /etc/security/limits.conf

echo "fs.file-max = 500000" | sudo tee --append /etc/sysctl.conf

# move udev rules and related scripts to the proper place
sudo mv /tmp/999-aws-ebs-nvme.rules /etc/udev/rules.d/999-aws-ebs-nvme.rules
sudo mv /tmp/ebs-nvme-mapping.sh /usr/local/sbin/ebs-nvme-mapping.sh
sudo chown root:root /etc/udev/rules.d/999-aws-ebs-nvme.rules /usr/local/sbin/ebs-nvme-mapping.sh
sudo chmod u+x /usr/local/sbin/ebs-nvme-mapping.sh
sudo chmod go-rwx /etc/udev/rules.d/999-aws-ebs-nvme.rules /usr/local/sbin/ebs-nvme-mapping.sh
