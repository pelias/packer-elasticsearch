#!/bin/bash -ex

cd /tmp

# note: the download servers changed between elasticsearch versions
ES_HOST='artifacts.elastic.co/downloads/elasticsearch'

# download elasticsearch .deb package
wget "https://${ES_HOST}/elasticsearch-${ELASTICSEARCH_VERSION}.deb"

# install .deb package
sudo dpkg -i "elasticsearch-${ELASTICSEARCH_VERSION}.deb"

# set permissions
cd /usr/share/elasticsearch
sudo chown elasticsearch:elasticsearch -R .

# install plugins
# see: https://www.elastic.co/guide/en/elasticsearch/plugins/5.6/cloud-aws.html
cd /usr/share/elasticsearch/bin
sudo ./elasticsearch-plugin install --verbose --batch analysis-icu
sudo ./elasticsearch-plugin install --verbose --batch repository-s3
sudo ./elasticsearch-plugin install --verbose --batch discovery-ec2

# enable the G1GC garbage collector on JVM10+
# https://medium.com/naukri-engineering/garbage-collection-in-elasticsearch-and-the-g1gc-16b79a447181
sudo sed -i 's/# 10-:-XX:-UseConcMarkSweepGC/10-:-XX:-UseConcMarkSweepGC/g' /etc/elasticsearch/jvm.options
sudo sed -i 's/# 10-:-XX:-UseCMSInitiatingOccupancyOnly/10-:-XX:-UseCMSInitiatingOccupancyOnly/g' /etc/elasticsearch/jvm.options
sudo sed -i 's/# 10-:-XX:+UseG1GC/10-:-XX:+UseG1GC/g' /etc/elasticsearch/jvm.options
sudo sed -i 's/# 10-:-XX:InitiatingHeapOccupancyPercent=75/10-:-XX:InitiatingHeapOccupancyPercent=75/g' /etc/elasticsearch/jvm.options
