#!/bin/bash 

IDENTITY_PATH=/root/.local/share/storj/identity/storagenode
STORAGE_PATH=/root/.local/share/storj/storagenode

if [ ! -f ${IDENTITY_PATH}/identity.key ] && [ ! -f ${IDENTITY_PATH}/identity.cert ] && [ ! -f ${IDENTITY_PATH}/ca.key ] && [ ! -f ${IDENTITY_PATH}/ca.cert ]; then
	identity create storagenode
fi

if [ "${AUTH_TOKEN}" != "" ] && [ $(ls -1 ${IDENTITY_PATH} | wc -l) -ne 6 ];then
	identity authorize storagenode ${AUTH_TOKEN} 
	exit_status=$?
	if [ $exit_status -eq 1 ]; then
    	echo "Please upload your identity files"
    	while true; do sleep 5; done
	fi
elif [ "${AUTH_TOKEN}" == "" ]; then
	echo "You must setup a AUTH_TOKEN, please check the documentation"
fi

if [ "${AUTH_TOKEN}" == "" ] || [ "${WALLET}" == "" ] || [ "${STORAGE}" == "" ]; then
    echo "Please provide all the config parameters: AUTH_TOKEN, WALLET, BANDWIDTH and STORAGE"
    while true; do sleep 5; done
fi

if [[ ! -f "${STORAGE_PATH}/config.yaml" ]]; then
	storagenode setup --config-dir ${STORAGE_PATH} --identity-dir ${IDENTITY_PATH}
fi

RUN_PARAMS="${RUN_PARAMS:-} --config-dir ${STORAGE_PATH}"
RUN_PARAMS="${RUN_PARAMS:-} --identity-dir ${IDENTITY_PATH}"
RUN_PARAMS="${RUN_PARAMS:-} --metrics.app-suffix=-alpha"
RUN_PARAMS="${RUN_PARAMS:-} --metrics.interval=30m"
RUN_PARAMS="${RUN_PARAMS:-} --contact.external-address=${_DAPPNODE_GLOBAL_HOSTNAME}:28967"
RUN_PARAMS="${RUN_PARAMS:-} --operator.email=${EMAIL}"
RUN_PARAMS="${RUN_PARAMS:-} --operator.wallet=${WALLET}"
RUN_PARAMS="${RUN_PARAMS:-} --storage.allocated-disk-space=${STORAGE}"
RUN_PARAMS="${RUN_PARAMS:-} --console.address=:80"

exec ./storagenode run $RUN_PARAMS "$@"
