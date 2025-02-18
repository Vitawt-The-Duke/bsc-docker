source /scripts/utils.sh

DATA_DIR=/root/.ethereum

wait_for_host_port ${BOOTSTRAP_HOST} ${BOOTSTRAP_TCP_PORT}
BOOTSTRAP_IP=$(get_host_ip $BOOTSTRAP_HOST)
VALIDATOR_ADDR=$(cat ${DATA_DIR}/address)
HOST_IP=$(hostname -i)

echo "validator id: ${HOST_IP}"

geth --config ${DATA_DIR}/config.toml --datadir ${DATA_DIR} --netrestrict ${CLUSTER_CIDR} \
    --verbosity ${VERBOSE} --nousb --ethstats ${NODE_ID}:${NETSTATS_URL} \
    --bootnodes enode://${BOOTSTRAP_PUB_KEY}@${BOOTSTRAP_IP}:${BOOTSTRAP_TCP_PORT} \
    --mine -unlock ${VALIDATOR_ADDR} --password "/passfile" \
    --light.serve 50 --pprof.addr 0.0.0.0 --metrics \
    --rpc.allow-unprotected-txs --txlookuplimit  15768000 \
    --miner.gaslimit ${GAS_LIMIT} \
    --miner.gastarget ${GAS_LIMIT} \
    --pprof