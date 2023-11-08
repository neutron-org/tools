# ===== VARIABLES

# ==================== mainnet fork (PICK)
GAS_PRICES="0.5untrn"
CHAINID="neutron-1"
TEST_WALLET="TODO"
KEYS_HOME="~/.neutrond-mainnet" # TODO
NODE="https://rpc-talzor.neutron-1.neutron.org:443" # TODO
ASTROPORT_NTRN_ATOM_ADDRESS="neutron1e22zh5p8meddxjclevuhjmfj69jxfsa8uu3jvht72rv9d8lkhves6t8veq"

# ==================== testnet (PICK)
GAS_PRICES="0.05untrn"
CHAINID="pion-1"
TEST_WALLET="TODO"
KEYS_HOME="~/.neutrond"
NODE="https://rpc-falcron.pion-1.ntrn.tech:443"
ASTROPORT_NTRN_ATOM_ADDRESS="TODO"

# ==================== COMMON CODE
# ===== ASTROPORT TEST
echo "Testing astroport"

ATOM_IBC_DENOM="ibc/C4CFF46FD6DE35CA4CF4CE031E643C8FDC9BA4B99AE598E9B0ED98FE3A2319F9"
EXECUTE_ARGS="--from ${TEST_WALLET} --gas 50000000 --chain-id ${CHAINID} --broadcast-mode=block --gas-prices ${GAS_PRICES}  -y --output json --keyring-backend test --home ${KEYS_HOME} --node ${NODE}"
QUERY_ARGS="--node $NODE --output json"

# neutrond tx wasm execute neutron1436kxs0w2es6xlqpp9rd35e3d0cjnw4sv8j3a7483sgks29jqwgshlt6zh '{"execute":{"proposal_id":5}}' --from $DEPLOYER --amount 1000000000untrn --gas 20000000 --gas-prices 0.9untrn --keyring-backend test --home $KEYS_HOME --chain-id=$LOCAL_CHAINID --node ${LOCAL_RPC} -y

echo "Swapping untrn for atom\n"
SWAP_MSG='{ "swap": { "offer_asset": { "info": { "native_token": { "denom": "untrn" } }, "amount": "10000000" } }'
RES=$(neutrond tx wasm execute ${ASTROPORT_NTRN_ATOM_ADDRESS} ${SWAP_MSG} ${EXECUTE_ARGS} --amount "10000000untrn")
echo $RES

echo "Balance on wallet: "
RES=$(neutrond q bank balances $ASTROPORT_NTRN_ATOM_ADDRESS ${QUERY_ARGS} --denom $ATOM_IBC_DENOM)
echo $RES

# RES=$(neutrond q wasm contract-state smart $ASTROPORT_NTRN_ATOM_ADDRESS '{"config":{}}' -o json | jq --raw-output ".data.owner")
