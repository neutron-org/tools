#!/bin/bash

. .env
DEPLOYER_ADDR=$(${BINARY} keys show ${DEPLOYER} --keyring-backend test -a --home ${KEYS_HOME})

PROPOSAL=$(cat ./proposal.json)

#bond
#${BINARY} tx wasm execute neutron1qeyjez6a9dwlghf9d6cy44fxmsajztw257586akk6xn6k88x0gus5djz4e '{"bond":{}}' --amount 10000000000000untrn --from demowallet2 --gas 200000 --gas-prices 0.0025untrn --keyring-backend test --home ${KEYS_HOME} --chain-id=neutron-1 -y --broadcast-mode block --node ${TESTNET_RPC}

RES=$(${BINARY} tx wasm execute  neutron1hulx7cgvpfcvg83wk5h96sedqgn72n026w6nl47uht554xhvj9nsgs8v0z "$PROPOSAL" --from demowallet2 --amount 1000000000untrn --gas-adjustment 1.4 --gas auto --gas-prices 0.0025untrn --keyring-backend test --home ${KEYS_HOME} --chain-id=neutron-1 -y --broadcast-mode block --node ${TESTNET_RPC} --output json)
echo $RES
PROP_ID=$(echo $RES | jq .logs[0].events[5].attributes[6].value -r)
echo $PROP_ID


# vote
${BINARY} tx wasm execute neutron1436kxs0w2es6xlqpp9rd35e3d0cjnw4sv8j3a7483sgks29jqwgshlt6zh '{"vote":{"proposal_id":'${PROP_ID}',"vote":"yes"}}' --from demowallet2 --amount 1000000000untrn --gas 20000000 --gas-prices 0.0025untrn --keyring-backend test --home ${KEYS_HOME} --chain-id=neutron-1 -y --node ${TESTNET_RPC} --broadcast-mode block

# execute
${BINARY} tx wasm execute neutron1436kxs0w2es6xlqpp9rd35e3d0cjnw4sv8j3a7483sgks29jqwgshlt6zh '{"execute":{"proposal_id":'${PROP_ID}'}}' --from demowallet2 --amount 1000000000untrn --gas 20000000 --gas-prices 0.0025untrn --keyring-backend test --home ${KEYS_HOME} --chain-id=neutron-1 -y --node ${TESTNET_RPC} --broadcast-mode block