#!/bin/bash -ex

cd

git clone https://github.com/orangejulius/elasticsearch-bash-utils

sudo cp elasticsearch-bash-utils/es_diagnostic.sh /usr/local/bin/ || true
sudo chmod uo+x /usr/local/bin/es_diagnostic.sh || true
