#!/bin/bash

DIRECTORY="./icons/tokens"
SLEEP_TIME=.1
ETHEREUM_ADDRESS="0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE"
SBTC_CURVE_ADDRESS="0xC25099792E9349C7DD09759744ea681C7de2cb66"

for folder_name in "$DIRECTORY"/*; do
  # check that .svg, 32px and 128 px exist
  names=("logo.svg" "logo-32.png" "logo-128.png")
  for file in ${names[@]}; do
    file="${folder_name}/${file}"
    if ! [ -f ${file} ]; then
      echo "Failed to find: ${file}"
      exit 1
    fi
  done

  token_address=$(basename ${folder_name})
  url="https://api.ethplorer.io/getTokenInfo/${token_address}?apiKey=${ETHPLORER_API_KEY}"

  token=$(curl -s ${url} | jq -c '. | { address, name, symbol, decimals, chainId: 1 }')

  # TODO: add separate check function
  if [ ${token_address} == ${ETHEREUM_ADDRESS} ]; then
    token="{'address':'${ETHEREUM_ADDRESS}','name':'Ethereum','symbol':'ETH','decimals':'18','chainId':1}"
  fi

  if [ ${token_address} == ${SBTC_CURVE_ADDRESS} ]; then
    token="{'address':'${SBTC_CURVE_ADDRESS}','name':'LP tBTC Curve','symbol':'TBTCCURVE','decimals':'18','chainId':1}"
  fi


  # check for broken response
  if [[ ${token} == *"null"* ]]; then
    echo "Failed to add token: ${token_address}"
    exit 1
  fi

  echo ${token} | jq .
  sleep ${SLEEP_TIME}

  # TODO:
  # save console output to file
done
