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
sudo ./elasticsearch-plugin install --verbose --batch discovery-ec2

# repository-s3 is a bundled module from Elasticsearch 8 onwards
if [[ "${ELASTICSEARCH_VERSION%%.*}" == "7" ]]; then
  sudo ./elasticsearch-plugin install --verbose --batch repository-s3
fi
