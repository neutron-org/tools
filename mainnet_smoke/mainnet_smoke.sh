# ===== FUNCTIONS
# wait for tx with timeout
function wait_for_tx() {
  local TX_HASH=$1
  local TIMEOUT=${2:-"60"}
  local SLEEP_TIME=${3:-"1"}
  local END_TIME=$(($(date +%s) + $TIMEOUT))
  while true; do
    local TX=$($BINARY query tx $TX_HASH --node $NODE --output json --chain-id $CHAIN_ID 2>&1)
    # check if tx has "not found" string in it
    local NF=$(echo $TX | grep -c "not found")
    if [[ $NF -eq 0 ]]; then
      local TX_STATUS=$(echo $TX | jq -r '.code')
      echo >&2 "Tx $TX_HASH succeeded"
      echo $TX
      break
    fi
    if [[ $(date +%s) -gt $END_TIME ]]; then
      echo >&2 "Tx $TX_HASH failed"
      exit 1
    fi
    sleep $SLEEP_TIME
  done
}

# ===== VARIABLES

# ==================== mainnet fork (PICK)
GAS_PRICES="0.5untrn"
CHAINID="neutron-1"
TEST_WALLET="TODO"
KEYS_HOME="~/.neutrond-mainnet" # TODO
NODE="https://rpc-talzor.neutron-1.neutron.org:443" # TODO
ASTROPORT_POOL_CONTRACT_ADDRESS="neutron1e22zh5p8meddxjclevuhjmfj69jxfsa8uu3jvht72rv9d8lkhves6t8veq" # NTRN-ATOM pool
TRANSFER_CHANNEL_ID="TODO"
TRANSFER_DESTINATION="cosmos1mwfj5j8v2aafqqnjekeqtupgc6894033nvtgre"
TRANSFER_DESTINATION_NODE="TODO"
CONNECTION_ID="TODO"
ICA_CONNECTION_ID="TODO"
ICA_NODE="TODO"
VALIDATOR_ADDR="TODO"

# ==================== testnet (PICK)
GAS_PRICES="0.05untrn"
CHAINID="pion-1"
TEST_WALLET="pion1_testnet_wallet" # neutron1mwfj5j8v2aafqqnjekeqtupgc6894033hnz2e7
KEYS_HOME="~/.neutrond"
NODE="https://rpc-falcron.pion-1.ntrn.tech:443"
ASTROPORT_POOL_CONTRACT_ADDRESS="neutron1j9eaaudut70pk7mhfnc48qugul0z53s3ygan60x7k3yj944wue6qpxlzdr"
TRANSFER_CHANNEL_ID="channel-96"
TRANSFER_DESTINATION="cosmos1mwfj5j8v2aafqqnjekeqtupgc6894033nvtgre"
TRANSFER_DESTINATION_NODE="https://rpc.provider-sentry-01.rs-testnet.polypore.xyz:443"
CONNECTION_ID="connection-42"
ICA_NODE="https://rpc.sentry-01.theta-testnet.polypore.xyz:443"
ICA_CONNECTION_ID="connection-129"
VALIDATOR_ADDR="cosmosvaloper10v6wvdenee8r9l6wlsphcgur2ltl8ztkfrvj9a"
# node ./bin/ibcheetah.js https://rest-falcron.pion-1.ntrn.tech provider
# cat out.json | fx 'x.filter(y => y.channel.port_id === "transfer" && y.channel.state === "STATE_OPEN" && y.connection.client_status === "Active")'


# ==================== COMMON CODE
# ===== ASTROPORT TEST
echo "Testing astroport"

EXECUTE_ARGS="--from ${TEST_WALLET} --gas 50000000 --chain-id ${CHAINID} --broadcast-mode=sync --gas-prices ${GAS_PRICES}  -y --output json --keyring-backend test --home ${KEYS_HOME} --node ${NODE}"
QUERY_ARGS="--node $NODE --output json"

echo "Swapping untrn for ${IBC_DENOM}\n"
RES_1=$(neutrond tx wasm execute ${ASTROPORT_POOL_CONTRACT_ADDRESS} '{"swap": {"offer_asset": {"info": {"native_token": {"denom": "untrn"}}, "amount": "100000"}}}' --from ${TEST_WALLET} --gas 50000000 --chain-id ${CHAINID} --broadcast-mode=sync --gas-prices ${GAS_PRICES}  -y --output json --keyring-backend test --home ${KEYS_HOME} --node ${NODE} --amount "100000untrn")
RES=$(neutrond q tx $(echo $RES_1 | jq -r '.txhash') --output json)
# RES=$(wait_for_tx $(echo $RES | jq -r '.txhash'))
echo $RES | jq -r '.raw_log'

echo "Balance on wallet: "
TEST_WALLET_ADDRESS=$(neutrond keys show $TEST_WALLET --keyring-backend test --output json | jq -r '.address')
RES=$(neutrond q bank balances $TEST_WALLET_ADDRESS --node $NODE --output json)
echo $RES
# TODO: search only for denom

# ===== IBC (requires ibc_setup.sh to be complete)

## Test ibc transfer from console

RES_1=$(neutrond tx ibc-transfer transfer "transfer" $TRANSFER_CHANNEL_ID $TRANSFER_DESTINATION "100untrn"  --from ${TEST_WALLET} --gas 5000000 --chain-id ${CHAINID} --broadcast-mode=sync --gas-prices ${GAS_PRICES}  -y --output json --keyring-backend test --home ${KEYS_HOME} --node ${NODE})
RES=$(neutrond q tx $(echo $RES_1 | jq -r '.txhash') --output json)
# wait...
gaiad q bank balances $TRANSFER_DESTINATION --node $TRANSFER_DESTINATION_NODE

## Test ibc transfer from contract (requires ibc_transfer contract)
echo "Deploying ibc transfer contract"
IBC_TRANSFER_STORE_RES_1=$(neutrond tx wasm store ./artifacts/ibc_transfer.wasm --from $TEST_WALLET --gas 500000 --gas-prices ${GAS_PRICES} --chain-id ${CHAINID} --keyring-backend test --home ${KEYS_HOME} --node ${NODE} --broadcast-mode=sync -y --output json)
IBC_TRANSFER_STORE_RES=$(neutrond q tx $(echo $IBC_TRANSFER_STORE_RES_1 | jq -r '.txhash') --output json)

IBC_TRANSFER_CODE_ID=$(echo $IBC_TRANSFER_STORE_RES | jq -r '.logs[0].events[1].attributes[1].value')
echo "IBC_TRANSFER_CODE_ID: ${IBC_TRANSFER_CODE_ID}"

IBC_TRANSFER_INSTANTIATE_RES_1=$(neutrond tx wasm instantiate ${IBC_TRANSFER_CODE_ID} '{}' --from $TEST_WALLET --gas 500000 --gas-prices ${GAS_PRICES} --chain-id ${CHAINID} --keyring-backend test --home ${KEYS_HOME} --node ${NODE} --broadcast-mode=sync -y --output json --label "ibc_transfer" --admin ${TEST_WALLET})
IBC_TRANSFER_INSTANTIATE_RES=$(neutrond q tx $(echo $IBC_TRANSFER_INSTANTIATE_RES_1 | jq -r '.txhash') --output json)
IBC_TRANSFER_ADDRESS=$(echo $IBC_TRANSFER_INSTANTIATE_RES | jq -r '.logs[0].events[0].attributes[0].value')
echo $IBC_TRANSFER_ADDRESS

## send money to contract
SEND_RES_1=$(neutrond tx bank send pion1_testnet_wallet ${IBC_TRANSFER_ADDRESS} 500000untrn  --gas-prices ${GAS_PRICES} --chain-id ${CHAINID} --keyring-backend test --home ${KEYS_HOME} --node ${NODE} --broadcast-mode=sync -y --output json)
SEND_RES=$(neutrond q tx $(echo $SEND_RES_1 | jq -r '.txhash') --output json)
CONTRACT_BALANCES=$(neutrond q bank balances $IBC_TRANSFER_ADDRESS --node $NODE --output json)
echo "IBC transfer contract balance: ${CONTRACT_BALANCES}"

## set ibc fee
SET_IBC_FEE_MSG='{"set_fees": {"recv_fee": "0", "ack_fee": "200000", "timeout_fee": "200000", "denom": "untrn"}}'
SET_IBC_FEE_RES_1=$(neutrond tx wasm execute $IBC_TRANSFER_ADDRESS $SET_IBC_FEE_MSG --from ${TEST_WALLET} --gas 50000000 --chain-id ${CHAINID} --broadcast-mode=sync --gas-prices ${GAS_PRICES}  -y --output json --keyring-backend test --home ${KEYS_HOME} --node ${NODE} --amount "100000untrn")
SET_IBC_FEE_RES=$(neutrond q tx $(echo $SET_IBC_FEE_RES_1 | jq -r '.txhash') --output json)
echo $SET_IBC_FEE_RES | jq -r '.raw_log'

## executing ibc transfer
IBC_TRANSFER_MSG='{"send": {"channel": "'"$TRANSFER_CHANNEL_ID"'", "to": "'"$TRANSFER_DESTINATION"'", "denom": "untrn", "amount": "100000"}}'
IBC_TRANSFER_RES_1=$(neutrond tx wasm execute $IBC_TRANSFER_ADDRESS $IBC_TRANSFER_MSG --from ${TEST_WALLET} --gas 50000000 --chain-id ${CHAINID} --broadcast-mode=sync --gas-prices ${GAS_PRICES}  -y --output json --keyring-backend test --home ${KEYS_HOME} --node ${NODE} --amount "100000untrn")
IBC_TRANSFER_RES=$(neutrond q tx $(echo $IBC_TRANSFER_RES_1 | jq -r '.txhash') --output json)
echo $IBC_TRANSFER_RES_1 | jq -r '.raw_log'
gaiad q bank balances $TRANSFER_DESTINATION --node $TRANSFER_DESTINATION_NODE
gaiad q ibc-transfer denom-trace TODO_IBC_DENOM --node $TRANSFER_DESTINATION_NODE

## Test ICA creation (requires neutron_interchain_txs contract)
echo "Deploying ICA transactions contract"
NEUTRON_INTERCHAIN_TXS_STORE_RES_1=$(neutrond tx wasm store ./artifacts/neutron_interchain_txs.wasm --from $TEST_WALLET --gas 5000000 --gas-prices ${GAS_PRICES} --chain-id ${CHAINID} --keyring-backend test --home ${KEYS_HOME} --node ${NODE} --broadcast-mode=sync -y --output json)
NEUTRON_INTERCHAIN_TXS_STORE_RES=$(neutrond q tx $(echo $NEUTRON_INTERCHAIN_TXS_STORE_RES_1 | jq -r '.txhash') --output json)
NEUTRON_INTERCHAIN_TXS_CODE_ID=$(echo $NEUTRON_INTERCHAIN_TXS_STORE_RES | jq -r '.logs[0].events[1].attributes[1].value')
echo "NEUTRON_INTERCHAIN_TXS_CODE_ID: ${NEUTRON_INTERCHAIN_TXS_CODE_ID}"

NEUTRON_INTERCHAIN_TXS_INSTANTIATE_RES_1=$(neutrond tx wasm instantiate ${NEUTRON_INTERCHAIN_TXS_CODE_ID} '{}' --from $TEST_WALLET --gas 500000 --gas-prices ${GAS_PRICES} --chain-id ${CHAINID} --keyring-backend test --home ${KEYS_HOME} --node ${NODE} --broadcast-mode=sync -y --output json --label "ibc_transfer" --admin ${TEST_WALLET})
NEUTRON_INTERCHAIN_TXS_INSTANTIATE_RES=$(neutrond q tx $(echo $NEUTRON_INTERCHAIN_TXS_INSTANTIATE_RES_1 | jq -r '.txhash') --output json)
NEUTRON_INTERCHAIN_TXS_ADDRESS=$(echo $NEUTRON_INTERCHAIN_TXS_INSTANTIATE_RES | jq -r '.logs[0].events[0].attributes[0].value')
echo $NEUTRON_INTERCHAIN_TXS_ADDRESS

## Test ICA transaction (delegate) (requires neutron_interchain_txs contract)
## Executing register ICA
INFO='{"connection_id": "'"$ICA_CONNECTION_ID"'", "interchain_account_id": "test2"}'
REGISTER_ICA_MSG='{"register": '"$INFO"'}'
REGISTER_ICA_RES_1=$(neutrond tx wasm execute $NEUTRON_INTERCHAIN_TXS_ADDRESS $REGISTER_ICA_MSG --from ${TEST_WALLET} --gas 50000000 --chain-id ${CHAINID} --broadcast-mode=sync --gas-prices ${GAS_PRICES}  -y --output json --keyring-backend test --home ${KEYS_HOME} --node ${NODE} --amount "100000untrn")
REGISTER_ICA_RES=$(neutrond q tx $(echo $REGISTER_ICA_RES_1 | jq -r '.txhash') --output json)
echo "Register ICA RES: $REGISTER_ICA_RES"

# TODO: does not work, why? (because ICA wasn't created?)
ICA_QUERY='{"interchain_account_address": '"$INFO"'}'
ICA_ADDRESS=$(neutrond q wasm contract-state smart $NEUTRON_INTERCHAIN_TXS_ADDRESS $ICA_QUERY -o json | jq --raw-output ".data.interchain_account_address")

ICA_QUERY_2='{"interchain_account_address_from_contract": {"interchain_account_id": "test2"}}'
ICA_ADDRESS=$(neutrond q wasm contract-state smart $NEUTRON_INTERCHAIN_TXS_ADDRESS $ICA_QUERY_2 -o json | jq --raw-output ".data[0]")


## send money to delegate to the contract
gaiad tx bank send mainnet_smoke $ICA_ADDRESS 300000uatom --keyring-backend test  --home ~/.gaiad-theta/ --node $ICA_NODE --chain-id theta-testnet-001 --gas 100000 --gas-prices 0.01uatom

# check
gaiad q bank balances $ICA_ADDRESS --node $ICA_NODE

## set ibc fees for interchaintxs contract
SET_IBC_FEE_MSG='{"set_fees": {"recv_fee": "0", "ack_fee": "200000", "timeout_fee": "200000", "denom": "untrn"}}'
SET_IBC_FEE_RES_1=$(neutrond tx wasm execute $NEUTRON_INTERCHAIN_TXS_ADDRESS $SET_IBC_FEE_MSG --from ${TEST_WALLET} --gas 50000000 --chain-id ${CHAINID} --broadcast-mode=sync --gas-prices ${GAS_PRICES}  -y --output json --keyring-backend test --home ${KEYS_HOME} --node ${NODE} --amount "100000untrn")
SET_IBC_FEE_RES=$(neutrond q tx $(echo $SET_IBC_FEE_RES_1 | jq -r '.txhash') --output json)
echo $SET_IBC_FEE_RES | jq -r '.raw_log'


## Executing delegate
INFO='{"interchain_account_id": "test2", "validator": "'"$VALIDATOR_ADDR"'", "amount": "100000", "denom": "uatom"}'
DELEGATE_ICA_MSG='{"delegate": '"$INFO"'}'
DELEGATE_ICA_RES_1=$(neutrond tx wasm execute $NEUTRON_INTERCHAIN_TXS_ADDRESS $DELEGATE_ICA_MSG --from ${TEST_WALLET} --gas 50000000 --chain-id ${CHAINID} --broadcast-mode=sync --gas-prices ${GAS_PRICES}  -y --output json --keyring-backend test --home ${KEYS_HOME} --node ${NODE} --amount "400000untrn")
REGISTER_ICA_RES=$(neutrond q tx $(echo $DELEGATE_ICA_RES_1 | jq -r '.txhash') --output json)

# check
gaiad q staking delegations $ICA_ADDRESS --node $ICA_NODE --output json
