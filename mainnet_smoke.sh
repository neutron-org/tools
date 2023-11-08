# ===== VARIABLES

ASTROPORT_CONTRACT="TODO"

# mainnet fork
GAS_PRICES="0.05untrn"
CHAINID="neutron-1"
TEST_WALLET="TODO"
KEYS_HOME="~/.neutrond-mainnet" # TODO
NODE="https://rpc-talzor.neutron-1.neutron.org:443" # TODO

# testnet
GAS_PRICES="0.05untrn"
CHAINID="pion-1"
TEST_WALLET="TODO"
KEYS_HOME="~/.neutrond"
NODE="https://rpc-falcron.pion-1.ntrn.tech:443"

# ===== ASTROPORT TEST
echo "Testing astroport"

  # neutrond tx wasm execute neutron1436kxs0w2es6xlqpp9rd35e3d0cjnw4sv8j3a7483sgks29jqwgshlt6zh '{"execute":{"proposal_id":5}}' --from $DEPLOYER --amount 1000000000untrn --gas 20000000 --gas-prices 0.9untrn --keyring-backend test --home $KEYS_HOME --chain-id=$LOCAL_CHAINID --node ${LOCAL_RPC} -y

MSG='{"execute":{"proposal_id":5}}'
RES=$(${NEUTROND_BIN} tx wasm execute ${ASTROPORT_CONTRACT} ${MSG} \
    --from ${TEST_WALLET} \
    --gas 50000000 \
    --chain-id ${CHAINID} \
    --broadcast-mode=block \
    --gas-prices ${GAS_PRICES}  -y \
    --output json \
    --keyring-backend test \
    --home ${KEYS_HOME} \
    --node ${NODE})
