#!/bin/bash
# Execute apt-get update if there are no Release files in /var/lib/apt/lists.
find /var/lib/apt/lists | grep 'Release$' > /dev/null 2>&1 || sudo apt-get -y update
