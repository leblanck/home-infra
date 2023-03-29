#!/bin/bash

#######
# Checking Home Public IP Address and comparing to DNS.
# If public DNS has changed then we need to update DNS via Netlify to point to new public IP. 
# This shuold be run internally. It will fail if run externaly
#######

# Colors
BGreen='\033[1;32m'
BRed='\033[1;31m'
NC='\033[0m'

SLACK_WEBHOOK_URL=''
SLACK_CHANNEL=''

setIP='127.0.0.1'
currentIP='dig +short myip.opendns.com @resolver1.opendns.com'

send_notification() {
  local color='good'
  if [ $1 == 'ERROR' ]; then
    color='danger'
  elif [ $1 == 'WARN' ]; then
    color = 'warning'
  fi
  local message="payload={\"channel\": \"#$SLACK_CHANNEL\",\"attachments\":[{\"pretext\":\"$2\",\"text\":\"$3\",\"color\":\"$color\"}]}"

  curl -X POST --data-urlencode "$message" ${SLACK_WEBHOOK_URL}
}

if [[ $setIP == "$currentIP" ]]; then
    echo -e "${BGreen}SUCCESS!${NC} - Current Public IP is set correctly. No Change Needed."
    send_notification 'INFO' "SUCCESS!" "Current Public IP is set correctly. No Change Needed."
else
    echo -e "${BRed}FAILURE${NC} - Current Public IP is NOT correct, adjust in Netlify ASAP"
    send_notification 'ERROR' "ERROR - DNS MISMATCH" "Current Public IP is NOT correct, adjust in Netlify ASAP"
fi
