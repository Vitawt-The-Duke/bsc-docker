#!/usr/bin/env bash

source /scripts/utils.sh

DATA_DIR=/root/.ethereum

account_cnt=$(ls ${DATA_DIR}/keystore | wc -l)
i=1
unlock_sequences="0"
while [ "$i" -lt ${account_cnt} ]; do
    unlock_sequences="${unlock_sequences},${i}"
    i=$(( i + 1 ))
done 

geth --config ${DATA_DIR}/config.toml --datadir ${DATA_DIR} --netrestrict ${CLUSTER_CIDR} \
    --verbosity ${VERBOSE} --nousb --ethstats ${NODE_ID}:${NETSTATS_URL} \
    --syncmode ${SYNC_MODE} --gcmode archive \
    --rpc.allow-unprotected-txs \
    --http --http.api ${API_MODULES} --http.vhosts '*' \
    --ws --ws.addr 0.0.0.0 --ws.port 8546 --ws.api ${API_MODULES} --ws.origins '*' \
    -unlock ${unlock_sequences} --password "/passfile"