# #!/bin/bash

# welcome message
echo "🕺 Welcome to the Proxy Dance! 🕺"

# get this script's current location
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# ask the user if the proxy is active to download private packages
read -p "Is your proxy tunnel running? [y/n]: " TUNNEL_RESPONSE

# exit the user from the program if no proxy is active
if [[ $TUNNEL_RESPONSE = y ]]
then
  echo "✅ NOMINAL - User reported active proxy tunnel. Proceeding..."
elif [[ $TUNNEL_RESPONSE = n ]]
then
  echo "❌ ERROR - Please start your proxy tunnel and rerun this script."
  exit 1
else
  echo "❌ ERROR - Unexpected response. Exiting..."
  exit 1
fi

# remove stale temp folder if it exists
cd $SCRIPT_DIR
if [ -d "${SCRIPT_DIR}/temp" ]
then 
  rm -r ./temp
fi

# build temp folder for parsed public and private dependencies
mkdir temp

echo "Installing package.json public dependencies..."

# get all the dependencies as json and pipe output 
npm ls --json --silent > ./temp/dependencies.json

# build list of package@version 
node ./parseDependencies.js public >> ./temp/publicDependencies.txt
node ./parseDependencies.js private >> ./temp/privateDependencies.txt

echo "✅ NOMINAL - Parsed public and private dependencies. Proceeding..."

# install public dependencies
PUBLIC_DEPENDENCIES=$( cat ./temp/publicDependencies.txt )
echo Attempting to install: $PUBLIC_DEPENDENCIES
npm install $PUBLIC_DEPENDENCIES --quiet

echo "Installing package.json private dependencies..."

# ask user for aide creds to install private repos
# read -p 'Enter PROXY username: ' PROXYUSERNAME
# read -p 'Enter PROXY password: ' PROXYPASSWORD 
read -p 'Enter PROXY PORT: ' PROXYPORT

# check if the proxy tunnel is still connected
ACTIVE_PROXY_PID_COUNT=$(lsof -i:$PROXYPORT | grep LISTEN | wc -l)
if [[ $ACTIVE_PROXY_PID_COUNT -gt 0 ]]
then
  echo "✅ NOMINAL - Active proxy tunnel detected, proceeding..."
else 
  echo " ❌ ERROR - No active proxy tunnel found, please start your proxy and rerun this script."
  echo "Exiting..."
  exit 1
fi

# export proxy vars
# PROXYVARS="http://${PROXYUSERNAME}:${PROXYPASSWORD}@127.0.0.1:${PROXYPORT}"
# export HTTP_PROXY=$PROXYVARS
# export HTTPS_PROXY=$PROXYVARS
# export FTP_PROXY=$PROXYVARS

# install private dependencies
PRIVATE_DEPENDENCIES=$( cat ./temp/privateDependencies.txt)
echo Attempting to install: $PRIVATE_DEPENDENCIES
npm install $PRIVATE_DEPENDENCIES --quiet

# unset proxy vars
# echo "unsetting proxy vars..."
# unset {HTTP,HTTPS,FTP}_PROXY

echo "************************************************"
echo "PROCESS COMPLETE"
echo "************************************************"

exit 0