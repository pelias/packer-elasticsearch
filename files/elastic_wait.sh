#!/bin/bash
set -e

# note: moved to shell script rather than being inline in a template file due to:
# https://github.com/terraform-providers/terraform-provider-template/issues/51

ELASTIC_RETRY_COUNT=${ELASTIC_RETRY_COUNT:-30}
ELASTIC_RETRY_TIMEOUT=${ELASTIC_RETRY_TIMEOUT:-1}

function elastic_status(){
  curl \
    --output /dev/null \
    --silent \
    --write-out "%{http_code}" \
    "http://${ELASTIC_HOST:-localhost:9200}/_cluster/health?wait_for_status=yellow&timeout=1s" \
      || true;
}

function elastic_wait(){
  echo 'waiting for elasticsearch service to come up';

  i=1
  while [[ "$i" -le "${ELASTIC_RETRY_COUNT}" ]]; do
    if [[ $(elastic_status) -eq 200 ]]; then
      echo "Elasticsearch up!"
      exit 0
    elif [[ $(elastic_status) -eq 408 ]]; then
      # 408 indicates the server is up but not yet yellow status
      printf ":"
    else
      printf "."
    fi
    sleep "${ELASTIC_RETRY_TIMEOUT}"
    i=$(($i + 1))
  done

  echo -e "\n"
  echo "Elasticsearch did not come up, check configuration"
  exit 1
}
