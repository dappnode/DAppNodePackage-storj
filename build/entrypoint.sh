#!/bin/sh 

IDENTITY_PATH=/root/.local/share/storj/identity/storagenode

if [ ! -f ${IDENTITY_PATH}/identity.key ] && [ ! -f ${IDENTITY_PATH}/identity.cert ] && [ ! -f ${IDENTITY_PATH}/ca.key ] && [ ! -f ${IDENTITY_PATH}/ca.cert ]; then
	identity_linux_amd64 create storagenode
fi

if [ "${AUTH_TOKEN}" != "" ] && [ $(ls -1 ${IDENTITY_PATH} | wc -l) -ne 6 ];then
	identity_linux_amd64 authorize storagenode ${AUTH_TOKEN} 
	exit_status=$?
	if [ $exit_status -eq 1 ]; then
    	echo "Please upload your identity files"
    	while true; do sleep 5; done
	fi
elif [ "${AUTH_TOKEN}" == "" ]; then
	echo "You must setup a AUTH_TOKEN, please check the documentation"
fi

if [ "${AUTH_TOKEN}" == "" ] || [ "${WALLET}" == "" ] || [ "${BANDWIDTH}" == "" ] || [ "${STORAGE}" == "" ]; then
    echo "Please provide all the config parameters: AUTH_TOKEN, WALLET, BANDWIDTH and STORAGE"
    while true; do sleep 5; done
fi

if [[ ! -f "config/config.yaml" ]]; then
	storagenode setup --config-dir config
fi

RUN_PARAMS="${RUN_PARAMS:-} --config-dir config"
RUN_PARAMS="${RUN_PARAMS:-} --metrics.app-suffix=-alpha"
RUN_PARAMS="${RUN_PARAMS:-} --metrics.interval=30m"
RUN_PARAMS="${RUN_PARAMS:-} --kademlia.external-address=${_DAPPNODE_GLOBAL_HOSTNAME}:28967"
RUN_PARAMS="${RUN_PARAMS:-} --kademlia.operator.email=${EMAIL}"
RUN_PARAMS="${RUN_PARAMS:-} --kademlia.operator.wallet=${WALLET}"
RUN_PARAMS="${RUN_PARAMS:-} --storage.allocated-bandwidth=${BANDWIDTH}"
RUN_PARAMS="${RUN_PARAMS:-} --storage.allocated-disk-space=${STORAGE}"
RUN_PARAMS="${RUN_PARAMS:-} --console.address=:80"
RUN_PARAMS="${RUN_PARAMS:-} --console.static-dir=/app"

exec storagenode run $RUN_PARAMS "$@"

