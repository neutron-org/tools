#!/bin/bash
set -e

NODE=${NODE:-"http://localhost:26657"}
KEY_NAME=${KEY_NAME:-"demowallet1"}
KEYRING=${KEYRING:-"test"}
CHAIN_ID=${CHAIN_ID:-"test-1"}
BINARY=${BINARY:-neutrond}
CHAINID=${CHAINID:-neutron-1}
STAKEDENOM=${STAKEDENOM:-untrn}
TGE_CONTRACTS_BINARIES_DIR=${TGE_CONTRACTS_BINARIES_DIR:-./artifacts}
DAO_CONTRACTS_BINARIES_DIR=${DAO_CONTRACTS_BINARIES_DIR:-./artifacts}
ASTROPORT_CONTRACTS_BINARIES_DIR=${ASTROPORT_CONTRACTS_BINARIES_DIR:-./artifacts} # TODO
GENESIS_PATH=${GENESIS_PATH:-./genesis.json}
TOKEN_INFO_MANAGER_MULTISIG_ADDRESS="neutron1m9l358xunhhwds0568za49mzhvuxx9ux8xafx2"


#load config
. ./contracts.txt


function query_contract() {
  CONTRACT=$1
  MESSAGE=$2
  $BINARY query wasm contract-state smart $CONTRACT "${MESSAGE}" --output json --chain-id $CHAIN_ID --home=home
}

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


function execute_contract() {
  echo >&2 ""
  echo >&2 "Executing contract $1 with message" $2
  CONTRACT=$1
  MESSAGE=$2
  SENDER=$3
  local RES=$($BINARY tx wasm execute $CONTRACT "${MESSAGE}" --from "$SENDER" --keyring-backend=$KEYRING  --node $NODE --output json --chain-id $CHAIN_ID --broadcast-mode async -y --gas auto --home=home --gas-prices 0.025untrn --gas-adjustment 1.5)
  RES=$(wait_for_tx $(echo $RES | jq -r '.txhash'))
  echo "$RES"
}

PAIRS_CONFIG=$(query_contract $ASTROPORT_FACTORY_CONTRACT_ADDRESS '{"pairs":{}}')
ASTRO_ATOM_PAIR=$(echo $PAIRS_CONFIG | jq -r '.data.pairs[0]')
ASTRO_USDC_PAIR=$(echo $PAIRS_CONFIG | jq -r '.data.pairs[1]')
ASTRO_ATOM_PAIR_TOKEN_ADDRESS=$(echo $ASTRO_ATOM_PAIR | jq -r '.contract_addr')
ASTRO_ATOM_PAIR_LP_TOKEN_ADDRESS=$(echo $ASTRO_ATOM_PAIR | jq -r '.liquidity_token')
ASTRO_USDC_PAIR_TOKEN_ADDRESS=$(echo $ASTRO_USDC_PAIR | jq -r '.contract_addr')
ASTRO_USDC_PAIR_LP_TOKEN_ADDRESS=$(echo $ASTRO_USDC_PAIR | jq -r '.liquidity_token')


LOCKDROP_MSG='{
  "set_token_info": {
      "atom_token": "'"$ASTRO_ATOM_PAIR_LP_TOKEN_ADDRESS"'",
      "usdc_token": "'"$ASTRO_USDC_PAIR_LP_TOKEN_ADDRESS"'",
      "generator": "'"$ASTROPORT_GENERATOR_CONTRACT_ADDRESS"'"
  }
}'

execute_contract $LOCKDROP_CONTRACT_ADDRESS "$LOCKDROP_MSG" "$TOKEN_INFO_MANAGER_MULTISIG_ADDRESS"

exit

SET_ATOM_VESTING_TOKEN_MSG='{
  "set_vesting_token": {
    "vesting_token": {
      "token": { "contract_addr": "'"$ASTRO_ATOM_PAIR_LP_TOKEN_ADDRESS"'" }
    }
  }
}'
SET_USDC_VESTING_TOKEN_MSG='{
  "set_vesting_token": {
    "vesting_token": {
      "token": { "contract_addr": "'"$ASTRO_USDC_PAIR_LP_TOKEN_ADDRESS"'" }
    }
  }
}'

execute_contract $ATOM_LP_VESTING_CONTRACT_ADDRESS "$SET_ATOM_VESTING_TOKEN_MSG" "$TOKEN_INFO_MANAGER_MULTISIG_ADDRESS"
execute_contract $USDC_LP_VESTING_CONTRACT_ADDRESS "$SET_USDC_VESTING_TOKEN_MSG" "$TOKEN_INFO_MANAGER_MULTISIG_ADDRESS"


SET_ASSET_INFOS_ATOM='{"set_asset_infos": [{"native_token":{"denom":"untrn"}},{"native_token":{"denom":"uibcatom"}}]}'
SET_ASSET_INFOS_USDC='{"set_asset_infos": [{"native_token":{"denom":"untrn"}},{"native_token":{"denom":"uibcusdc"}}]}'

execute_contract $ATOM_TWAP_CONTRACT_ADDRESS "$SET_ASSET_INFOS_ATOM" "$TOKEN_INFO_MANAGER_MULTISIG_ADDRESS"
execute_contract $USDC_TWAP_CONTRACT_ADDRESS "$SET_ASSET_INFOS_USDC" "$TOKEN_INFO_MANAGER_MULTISIG_ADDRESS"