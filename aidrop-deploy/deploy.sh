#!/bin/bash
set -e
set -x

BINARY=${BINARY:-neutrond}
CHAINID=${CHAINID:-pion-1}
STAKEDENOM=${STAKEDENOM:-untrn}
TGE_CONTRACTS_BINARIES_DIR=${TGE_CONTRACTS_BINARIES_DIR:-../../neutron-integration-tests/contracts}
NODE_ADDRESS="https://rpc-palvus.pion-1.ntrn.tech:443"
AIRDROP_DISTRIBUTION_PATH="./distribution.json"

CREDITS_BINARY=$TGE_CONTRACTS_BINARIES_DIR/credits.wasm
AIRDROP_BINARY=$TGE_CONTRACTS_BINARIES_DIR/cw20_merkle_airdrop.wasm

ADMIN_ACCOUNT_NAME="airdrop_admin"
ADMIN_ADDRESS=$($BINARY keys show "$ADMIN_ACCOUNT_NAME" -a --keyring-backend test)

let CREDITS_WHEN_WITHDRAWABLE="$CHAIN_START + 2 * 60 * 60"

AIRDROP_MERKLE_ROOT=$(merkle-airdrop-cli generateRoot --file "$AIRDROP_DISTRIBUTION_PATH")
AIRDROP_START=$(date +%s)
let AIRDROP_DURATION_SECONDS="7 * 24 * 60 * 60" # 7 days
AIRDROP_AMOUNT="$(cat "$AIRDROP_DISTRIBUTION_PATH" | jq '[.[] | .amount | tonumber] | add')untrn"

function store_binary() {
  CONTRACT_BINARY_PATH=$1
  TX_HASH=$($BINARY tx wasm store "$CONTRACT_BINARY_PATH" --from "$ADMIN_ACCOUNT_NAME" \
   --keyring-backend test --node "$NODE_ADDRESS" --chain-id "$CHAINID" --gas 5000000 --fees 12500untrn -y -b block -o json | jq -r '.txhash')

  CODE_ID=$($BINARY q tx "$TX_HASH" --node "$NODE_ADDRESS" --chain-id "$CHAINID" -o json | \
    jq -r '.logs[].events[] | select(.type=="store_code") | .attributes[] | select(.key=="code_id") | .value')

  echo "$CODE_ID"
}

function instantiate_contract() {
  CODE_ID=$1
  INIT_MSG=$2
  LABEL=$3
  TX_HASH=$(neutrond tx wasm instantiate "$CODE_ID" "$INIT_MSG" --admin="$ADMIN_ADDRESS" --label="$LABEL" --from "$ADMIN_ACCOUNT_NAME" \
   --keyring-backend test --node "$NODE_ADDRESS" --chain-id "$CHAINID" --gas 5000000 --fees 12500untrn -y -b block -o json | jq -r '.txhash')

   ADDRESS=$($BINARY q tx "$TX_HASH" --node "$NODE_ADDRESS" --chain-id "$CHAINID" -o json | \
     jq -r '.raw_log | fromjson | .[].events[] | select(.type == "instantiate") | .attributes[] | select(.key == "_contract_address") | .value')
  echo "$ADDRESS"
}

function execute_contract() {
  CONTRACT=$1
  MESSAGE=$2
  neutrond tx wasm execute "$CONTRACT" "$MESSAGE" --from "$ADMIN_ACCOUNT_NAME" \
     --keyring-backend test --node "$NODE_ADDRESS" --chain-id "$CHAINID" --gas 5000000 --fees 12500untrn -y -b block -o json
}

function execute_contract_w_funds() {
  CONTRACT=$1
  MESSAGE=$2
  FUNDS=$3
  neutrond tx wasm execute "$CONTRACT" "$MESSAGE" --amount $FUNDS --from "$ADMIN_ACCOUNT_NAME" \
       --keyring-backend test --node "$NODE_ADDRESS" --chain-id "$CHAINID" --gas 5000000 --fees 13000untrn -y -b block -o json
}

AIDROP_CONTRACT_BINARY_ID=$(store_binary "$AIRDROP_BINARY")
CREDITS_CONTRACT_BINARY_ID=$(store_binary "$CREDITS_BINARY")

CREDITS_INIT_MSG='{
  "dao_address": "'"$ADMIN_ADDRESS"'"
}'

CREDITS_CONTRACT_ADDRESS=$(instantiate_contract "$CREDITS_CONTRACT_BINARY_ID" "$CREDITS_INIT_MSG" "TGE_NEUTRON_CREDITS" "$ADMIN_ADDRESS")

AIRDROP_INIT_MSG='{
  "credits_address": "'"$CREDITS_CONTRACT_ADDRESS"'",
  "reserve_address": "'"$ADMIN_ADDRESS"'",
  "merkle_root": "'"$AIRDROP_MERKLE_ROOT"'",
  "airdrop_start": '$AIRDROP_START',
  "vesting_start": '$AIRDROP_START',
  "vesting_duration_seconds": '$AIRDROP_DURATION_SECONDS'
}'

AIDROP_CONTRACT_ADDRESS=$(instantiate_contract "$AIDROP_CONTRACT_BINARY_ID" "$AIRDROP_INIT_MSG" "TGE_NEUTRON_AIRDROP" "$MAIN_DAO_ADDRESS")

CREDITS_UPDATE_CONFIG_MSG='{
  "update_config": {
    "config": {
      "airdrop_address": "'"$AIDROP_CONTRACT_ADDRESS"'",
      "lockdrop_address": "'"$ADMIN_ADDRESS"'",
      "when_withdrawable": '$CREDITS_WHEN_WITHDRAWABLE'
    }
  }
}'
execute_contract $CREDITS_CONTRACT_ADDRESS "$CREDITS_UPDATE_CONFIG_MSG"

CREDITS_MINT_MSG='{
  "mint": {}
}'
execute_contract_w_funds $CREDITS_CONTRACT_ADDRESS "$CREDITS_MINT_MSG" "$AIRDROP_AMOUNT"

echo "Airdrop contract address: $AIDROP_CONTRACT_ADDRESS"
echo "Credits contract address: $CREDITS_CONTRACT_ADDRESS"
