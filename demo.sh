#!/bin/bash

username="elastic"
password="changeme"
url="http://localhost:9200"  # replace with your Elasticsearch URL if different
kibana_url="http://localhost:5601"  # replace with your Kibana URL if different

echo "Waiting for Kibana to be online..."
while true; do
    # Check if the API status endpoint is available
    response=$(curl -v -u "${username}:${password}" ${kibana_url}${dev_prefix}/api/status 2>&1)

    if echo "$response" | grep -q "HTTP/.* 200 OK"; then
        break
    fi
    # Attempt to get the dev prefix of the instance
    if [[ -z "$dev_prefix" ]]; then
        response=$(curl -v ${kibana_url} 2>&1)
        if echo "$response" | grep -q "HTTP/1.1 302 Found"; then
          dev_prefix=$(echo "$response" | grep -i "location:" | cut -d':' -f2- | tr -d '[:space:]')
        fi
    fi

    printf "."
    sleep 5
done

printf "Hi!" 
